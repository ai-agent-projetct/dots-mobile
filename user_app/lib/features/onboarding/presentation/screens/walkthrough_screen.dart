import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:resize/resize.dart';
import 'package:user/config/app_routes.dart';
import 'package:user/constants/app_colors.dart';
import 'package:user/constants/app_constants.dart';
import 'package:user/constants/app_strings.dart';
import 'package:user/di/di.dart';
import 'package:user/features/onboarding/data/models/config_model.dart';
import 'package:user/features/onboarding/presentation/provider/onboarding_provider.dart';
import 'package:user/utils/services/prefs.dart';
import 'package:user/widgets/app_images.dart';
import 'package:user/widgets/app_text.dart';

class WalkThroughScreen extends ConsumerStatefulWidget {
  const WalkThroughScreen({super.key});

  @override
  WalkThroughScreenState createState() => WalkThroughScreenState();
}

class WalkThroughScreenState extends ConsumerState<WalkThroughScreen> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
      ),
    );
    var mOnBoardingProvider = ref.watch(onBoardingProvider);
    return Scaffold(
      backgroundColor: AppColors.white,
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is OverscrollNotification) {
            if (mOnBoardingProvider.pageIndex ==
                    mOnBoardingProvider.configModel!.data!.slider!.length - 1 &&
                !mOnBoardingProvider.isLastIndex) {
              mOnBoardingProvider.isLastIndex = true;
              mOnBoardingProvider.completeOnboarding();
            }
          }
          return false;
        },
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //   SizedBox(height: AppConstants.safeAreaHeight + 10.h),
              Padding(
                padding: EdgeInsets.only(right: 20.w),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                      Prefs().setBool(Prefs.isWalkThroughCompleted, true);
                      Navigator.pushReplacementNamed(
                        context,
                        AppRoutes.loginScreen,
                      );
                    },
                    child: AppText(
                      translate(AppStringsKey.skip),
                      textSize: 16,
                      fontWeight: FontWeight.w500,
                      textDecoration: TextDecoration.underline,
                      lineHeight: 2.h,
                      textColor: AppColors.black,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  itemCount:
                      mOnBoardingProvider.configModel!.data!.slider!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return sliderWidget(
                      mOnBoardingProvider.configModel!.data!.slider![index],
                    );
                  },
                  controller: mOnBoardingProvider.pageController,
                  onPageChanged: mOnBoardingProvider.onPageChanged,
                ),
              ),
              sliderIndicatorWidget(mOnBoardingProvider),
              SizedBox(height: AppConstants.safeAreaHeight + 5.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget sliderIndicatorWidget(OnboardingProvider mOnBoardingProvider) {
    return SizedBox(
      height: 50.h,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: mOnBoardingProvider.configModel!.data!.slider!.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 2.w),
            height: 10.h,
            width: 10.w,
            decoration: BoxDecoration(
              color:
                  mOnBoardingProvider.pageIndex == index
                      ? AppColors.primary
                      : const Color.fromARGB(101, 225, 225, 225),
              shape: BoxShape.circle,
            ),
          );
        },
      ),
    );
  }

  Widget sliderWidget(SliderModel slider) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.h),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: AppNetworkImage(
              url: slider.image.toString(),
              fit: BoxFit.fitWidth,
              height: AppConstants.screenHeight * 0.5,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 30.h),
          alignment: Alignment.center,
          child: AppText(
            slider.description.toString(),
            textSize: 22,
            textAlign: TextAlign.center,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

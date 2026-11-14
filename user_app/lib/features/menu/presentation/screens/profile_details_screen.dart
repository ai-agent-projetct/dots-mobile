import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:resize/resize.dart';
import 'package:user/config/app_routes.dart';
import 'package:user/constants/app_colors.dart';
import 'package:user/constants/app_constants.dart';
import 'package:user/constants/app_images.dart';
import 'package:user/constants/app_strings.dart';
import 'package:user/di/di.dart';
import 'package:user/features/menu/presentation/provider/profile_provider.dart';
import 'package:user/main.dart';
import 'package:user/widgets/app_bar.dart';
import 'package:user/widgets/app_images.dart';
import 'package:user/widgets/app_text.dart';
import 'package:user/widgets/common_widgets.dart';
import 'package:user/widgets/image_picker_widget.dart';
import 'package:user/widgets/loading_widget.dart';

class ProfileDetailsScreen extends ConsumerStatefulWidget {
  const ProfileDetailsScreen({super.key});

  @override
  ProfileDetailsScreenState createState() => ProfileDetailsScreenState();
}

class ProfileDetailsScreenState extends ConsumerState<ProfileDetailsScreen> {
  late ProfileProvider mProfileProvider;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      mProfileProvider.getProfile();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    mProfileProvider = ref.watch(profileProvider);
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        debugPrint('pop scope called from profile view ---- $didPop');
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Column(
            children: [
              CustomAppBar(
                title: translate(AppStringsKey.profileDetails),
                showLeadingIcon: true,
                leadingIconEnabled: true,
                onTap: () {
                  Navigator.of(context).pop();
                },
                textSize: 16.sp,
              ),
              Expanded(
                child:
                    mProfileProvider.isLoading ||
                            mProfileProvider.profileData == null
                        ? LoadingWidget()
                        : SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              headerContainer(),
                              SizedBox(height: 10.h),
                              accountField(
                                placeholderName: translate(
                                  AppStringsKey.fullName,
                                ),
                                fieldName:
                                    mProfileProvider.profileData!.fullName
                                        .toString(),
                                onTap:
                                    () => navigateToUpdateScreen(
                                      ApiConstants.fullName,
                                      mProfileProvider.profileData!.fullName
                                          .toString(),
                                      translate(AppStringsKey.updateFullName),
                                      '',
                                    ),
                              ),
                              horizontalSeparatorWidget(),
                              accountField(
                                placeholderName: translate(
                                  AppStringsKey.mobileNumber,
                                ),
                                fieldName:
                                    mProfileProvider.profileData!.mobile
                                        .toString(),
                                onTap:
                                    () => navigateToUpdateScreen(
                                      ApiConstants.mobile,
                                      mProfileProvider.profileData!.mobile
                                          .toString(),
                                      translate(AppStringsKey.updateMobile),
                                      '',
                                    ),
                              ),
                              horizontalSeparatorWidget(),
                              accountField(
                                placeholderName: translate(
                                  AppStringsKey.emailAddress,
                                ),
                                fieldName:
                                    mProfileProvider.profileData!.email
                                        .toString(),
                                onTap:
                                    () => navigateToUpdateScreen(
                                      ApiConstants.email,
                                      mProfileProvider.profileData!.email
                                          .toString(),
                                      translate(AppStringsKey.updateEmail),
                                      '',
                                    ),
                              ),
                              horizontalSeparatorWidget(),
                              InkWell(
                                onTap: () {
                                  mProfileProvider.userCheck(
                                    mProfileProvider.profileData!.mobile
                                        .toString(),
                                    'Password',
                                  );
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: 10.0.w,
                                    right: 10.0.w,
                                    top: 20.0.h,
                                    bottom: 20.0.h,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      AppText(
                                        translate(AppStringsKey.changePwd),
                                        textColor: AppColors.red,
                                        textSize: 12.sp,
                                      ),
                                      Image.asset(
                                        AppImages.rightArrowIcon,
                                        color: AppColors.iconGreyColor,
                                        width: 15.w,
                                        height: 15.h,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              horizontalSeparatorWidget(),
                            ],
                          ),
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget headerContainer() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.h),
      width: double.infinity,
      color: AppColors.splashBgColor,
      child: Column(
        children: [
          InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                enableDrag: false,
                backgroundColor: AppColors.transparent,
                builder:
                    (context) => ImagePickerWidget(
                      data: (file) {
                        if (file.existsSync()) {
                          mProfileProvider.uploadFile(file);
                        }
                      },
                    ),
              );
            },
            child: Stack(
              children: [
                Container(
                  height: 80.h,
                  width: 80.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.white,
                    border: Border.all(
                      color: AppColors.profileGreyBorder,
                      width: 1.w,
                    ),
                  ),
                  child: AppNetworkImage(
                    url: mProfileProvider.profileData!.image.toString(),
                    boxShape: BoxShape.circle,
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Image.asset(AppImages.profileCapture, width: 25.w),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

navigateToUpdateScreen(String key, String data, String title, String desc) {
  var body = {'keyName': key, 'data': data, 'title': title, 'desc': desc};
  Navigator.pushNamed(
    navigatorKey.currentState!.context,
    AppRoutes.profileUpdate,
    arguments: body,
  );
}

accountField({
  required String placeholderName,
  Color placeholderColor = AppColors.grey2,
  required String fieldName,
  required void Function() onTap,
}) {
  return Padding(
    padding: EdgeInsets.only(left: 10.w, right: 10.w),
    child: GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Container(
              color: AppColors.transparent,
              padding: EdgeInsets.symmetric(vertical: 15.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    placeholderName,
                    textColor: placeholderColor,
                    textSize: 10.sp,
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText(
                        fieldName,
                        textColor: AppColors.secondary,
                        textSize: 12.sp,
                      ),
                      Image.asset(
                        AppImages.rightArrowIcon,
                        color: AppColors.iconGreyColor,
                        width: 15.w,
                        height: 15.h,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

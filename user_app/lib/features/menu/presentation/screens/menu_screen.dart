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
import 'package:user/features/menu/presentation/widgets/logout_dialog.dart';
import 'package:user/utils/helpers/extension.dart';
import 'package:user/utils/services/prefs.dart';
import 'package:user/widgets/app_bar.dart';
import 'package:user/widgets/app_images.dart';
import 'package:user/widgets/app_text.dart';
import 'package:user/widgets/change_language.dart';

class MenuScreen extends ConsumerStatefulWidget {
  const MenuScreen({super.key});

  @override
  MenuScreenState createState() => MenuScreenState();
}

class MenuScreenState extends ConsumerState<MenuScreen> {
  late ProfileProvider mProfileProvider;
  @override
  Widget build(BuildContext context) {
    mProfileProvider = ref.watch(profileProvider);
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SizedBox(
          width: ResizeUtil().screenWidth,
          height: ResizeUtil().screenHeight,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //SizedBox(height: AppConstants.safeAreaHeight),
                CustomAppBar(
                  title: translate(AppStringsKey.menuText),
                  leadingIconHeight: 22.5.h,
                  textSize: 16.sp,
                  showLeadingIcon: true,
                  leadingIconEnabled: true,
                  onTap: () {
                    ref.read(homeProvider).onItemTap(0);
                  },
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: AppColors.backgroundGrey,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 20.h,
                      horizontal: 20.w,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile Image
                        Container(
                          height: 60.h,
                          width: 60.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.white,
                            border: Border.all(
                              color: AppColors.profileGreyBorder,
                              width: 1.w,
                            ),
                          ),
                          child: AppNetworkImage(
                            url: Prefs().getString(Prefs.userImage).toString(),
                            boxShape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 5.w),
                        // Profile Info
                        Expanded(
                          child: SizedBox(
                            height: 60.h,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  Prefs()
                                      .getString(Prefs.fullName)
                                      .toString()
                                      .capitalize(),
                                  fontFamily: AppStringsKey.roboto,
                                  overflow: TextOverflow.ellipsis,
                                  textColor: AppColors.lightenGrey,
                                  textAlign: TextAlign.start,
                                  fontWeight: FontWeight.w500,
                                  textSize: 12.sp,
                                ),
                                SizedBox(height: 5.h),
                                AppText(
                                  '+91 ${Prefs().getString(Prefs.mobile).toString()}',
                                  fontFamily: AppStringsKey.roboto,
                                  textColor: AppColors.lightenGrey,
                                  textAlign: TextAlign.start,
                                  fontWeight: FontWeight.w400,
                                  textSize: 13.sp,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 60.h,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 35.w,
                                height: 35.h,
                                child: IconButton(
                                  onPressed: () async {
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.profileScreen,
                                    );
                                  },
                                  icon: Image.asset(
                                    AppImages.edit,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Column(
                  children: [
                    _buildMenuItem(
                      AppStringsKey.interestTitle,
                      AppImages.interest,
                      AppRoutes.offersPage,
                      context,
                      ref,
                    ),
                    _buildMenuItem(
                      AppStringsKey.photosVideoTitle,
                      AppImages.photosVideos,
                      AppRoutes.trendsPage,
                      context,
                      ref,
                    ),
                    _buildMenuItem(
                      AppStringsKey.subscriptionTitle,
                      AppImages.subscription,
                      AppRoutes.subscriptionHistory,
                      context,
                      ref,
                    ),

                    _buildMenuItem(
                      AppStringsKey.notificationTitle,
                      AppImages.notification,
                      '',
                      context,
                      ref,
                    ),
                    _buildMenuItem(
                      AppStringsKey.languagesTitle,
                      AppImages.languages,
                      'Change Language',
                      context,
                      ref,
                    ),
                    _buildMenuItem(
                      AppStringsKey.helpSupportTitle,
                      AppImages.support,
                      '',
                      context,
                      ref,
                    ),
                    _buildMenuItem(
                      AppStringsKey.aboutTitle,
                      AppImages.about,
                      '',
                      context,
                      ref,
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.only(left: 20.w, right: 20.w),
                  child: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => LogoutDialog(),
                      );
                    },
                    child: Container(
                      height: AppConstants.screenHeight * 0.06,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0.r),
                        color: AppColors.white,
                        border: Border.all(
                          color: AppColors.primary,
                          width: 1.0.w,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            AppImages.logout,
                            height: 20.h,
                            width: 20.w,
                            fit: BoxFit.fill,
                          ),
                          SizedBox(width: 5.w),
                          AppText(
                            translate(AppStringsKey.logout),
                            fontFamily: AppStringsKey.poppins,
                            textSize: 14.sp,
                            textColor: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method for building menu items
  Widget _buildMenuItem(
    String title,
    String imageUrl,
    String route,
    BuildContext context,
    WidgetRef ref,
  ) {
    return Padding(
      padding: EdgeInsets.only(left: 20.w, top: 5.h, bottom: 5.h),
      child: InkWell(
        onTap: () {
          if (route == 'Change Language') {
            ChangeLanguage().showLanguageDialog(context, ref);
          } else {
            if (route.isNotEmpty) {
              if (route == AppRoutes.offersPage) {
                ref.read(homeProvider).onItemTap(1);
              } else if (route == AppRoutes.trendsPage) {
                ref.read(homeProvider).onItemTap(2);
              } else {
                Navigator.pushNamed(context, route);
              }
            }
          }
        },
        child: SizedBox(
          height: 40.h,
          width: ResizeUtil().screenWidth,
          child: Row(
            children: [
              Image.asset(
                imageUrl,
                height: 20.h,
                width: 20.w,
                fit: BoxFit.contain,
              ),
              SizedBox(width: 20.w),
              Expanded(
                child: AppText(
                  translate(title),
                  textColor: AppColors.lightenGrey,
                  textAlign: TextAlign.start,
                  fontWeight: FontWeight.w400,
                  textSize: 13.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

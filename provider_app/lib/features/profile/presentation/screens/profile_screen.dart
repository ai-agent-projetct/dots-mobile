import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/config/app_routes.dart';
import 'package:provider/constants/app_colors.dart';
import 'package:provider/constants/app_images.dart';
import 'package:provider/constants/app_strings.dart';
import 'package:provider/di/di.dart';
import 'package:provider/features/profile/presentation/widgets/addservice_dialog.dart';
import 'package:provider/features/profile/presentation/widgets/logout_dialog.dart';
import 'package:provider/utils/helpers/extension.dart';
import 'package:provider/utils/services/prefs.dart';
import 'package:provider/widgets/app_bar.dart';
import 'package:provider/widgets/app_images.dart';
import 'package:provider/widgets/app_text.dart';
import 'package:provider/widgets/change_language.dart';
import 'package:resize/resize.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final firstName =
        Prefs().getString(Prefs.firstName).toString().capitalize();
    final lastName = Prefs().getString(Prefs.lastName).toString().capitalize();

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Column(
            children: [
              // Fixed AppBar
              CustomAppBar(
                title: translate(AppStringsKey.profile),
                leadingIconHeight: 22.5.h,
                textSize: 16.sp,
                showLeadingIcon: true,
                leadingIconEnabled: true,
                onTap: () {
                  ref.read(homeProvider).onItemTap(2);
                },
              ),

              // Scrollable Body
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Profile Info
                      Container(
                        color: AppColors.backgroundGrey,
                        padding: EdgeInsets.symmetric(
                          vertical: 20.h,
                          horizontal: 20.w,
                        ),
                        child: Row(
                          children: [
                            // Avatar
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
                                url:
                                    Prefs()
                                        .getString(Prefs.profileImage)
                                        .toString(),
                                boxShape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 10.w),

                            // Name and Phone
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppText(
                                    '$firstName $lastName',

                                    fontFamily: AppStringsKey.roboto,
                                    overflow: TextOverflow.ellipsis,
                                    textColor: AppColors.lightenGrey,
                                    fontWeight: FontWeight.w500,
                                    textSize: 12.sp,
                                  ),
                                  SizedBox(height: 5.h),
                                  AppText(
                                    '+91 ${Prefs().getString(Prefs.mobile)}',
                                    fontFamily: AppStringsKey.roboto,
                                    textColor: AppColors.lightenGrey,
                                    fontWeight: FontWeight.w400,
                                    textSize: 13.sp,
                                  ),
                                ],
                              ),
                            ),

                            // Edit Icon
                            IconButton(
                              icon: Image.asset(
                                AppImages.edit,
                                height: 24.h,
                                width: 24.w,
                              ),
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.editProfile,
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      // Menu Items
                      SizedBox(height: 20.h),
                      ...[
                        _buildMenuItem(
                          "Appointment",
                          AppImages.interest,
                          AppRoutes.appointment,
                        ),
                        _buildMenuItem(
                          "Category",
                          AppImages.interest,
                          AppRoutes.category,
                        ),
                        _buildMenuItem(
                          AppStringsKey.photosVideoTitle,
                          AppImages.photosVideos,
                          AppRoutes.photosandvideos,
                        ),

                        _buildMenuItem(
                          AppStringsKey.notificationTitle,
                          AppImages.notification,
                          AppRoutes.notification,
                        ),
                        _buildMenuItem(
                          AppStringsKey.languagesTitle,
                          AppImages.languages,
                          'Change Language',
                        ),
                        _buildMenuItem(
                          AppStringsKey.aboutTitle,
                          AppImages.about,
                          AppRoutes.about,
                        ),
                      ],
                      SizedBox(height: 20.h),
                      // Logout Button
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) => LogoutDialog(),
                            );
                          },
                          child: Container(
                            height: 45.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.r),
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
                                ),
                                SizedBox(width: 8.w),
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
                      SizedBox(height: 20.h),
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

  /// Menu Item Builder
  Widget _buildMenuItem(String title, String icon, String route) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 20.w),
      child: InkWell(
        onTap: () {
          if (route == 'Change Language') {
            ChangeLanguage().showLanguageDialog(context, ref);
          } else {
            Navigator.pushNamed(context, route);
          }
        },
        child: SizedBox(
          height: 40.h,
          child: Row(
            children: [
              Image.asset(icon, height: 20.h, width: 20.w, fit: BoxFit.contain),
              SizedBox(width: 20.w),
              Expanded(
                child: AppText(
                  translate(title),
                  textColor: AppColors.lightenGrey,
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

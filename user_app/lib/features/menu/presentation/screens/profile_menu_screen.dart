import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resize/resize.dart';
import 'package:user/constants/app_colors.dart';
import 'package:user/constants/app_images.dart';
import 'package:user/constants/app_strings.dart';
import 'package:user/di/di.dart';
import 'package:user/features/menu/presentation/widgets/logout_dialog.dart';

import 'package:user/widgets/app_text.dart';
import 'package:user/config/app_routes.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:user/widgets/change_language.dart';
import 'package:user/widgets/profilecircular.dart';

class ProfileMenuScreen extends ConsumerStatefulWidget {
  const ProfileMenuScreen({super.key});

  @override
  ConsumerState<ProfileMenuScreen> createState() => _ProfileMenuScreenState();
}

class _ProfileMenuScreenState extends ConsumerState<ProfileMenuScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileProvider).loadPrefs();
    });
  }

  @override
  Widget build(BuildContext context) {
    final mprofileProvider = ref.watch(profileProvider);

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Center(child: Image.asset(AppImages.appLogo, height: 35.h)),
                Positioned(
                  right: 0,
                  top: 0,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20.h),

            // White inner card area
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
              padding: EdgeInsets.all(15.w),
              child: Column(
                children: [
                  // Profile row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ProfileCircleAvatar(
                        imageUrl: mprofileProvider.userImage,
                        radius: 30.w,
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              mprofileProvider.userName,
                              fontFamily: AppStringsKey.roboto,
                              textColor: AppColors.lightenGrey,
                              textAlign: TextAlign.start,
                              fontWeight: FontWeight.w500,
                              textSize: 14.sp,
                            ),
                            SizedBox(height: 4.h),
                            AppText(
                              '+91 ${mprofileProvider.mobile}',
                              fontFamily: AppStringsKey.roboto,
                              textColor: AppColors.lightenGrey,
                              textAlign: TextAlign.start,
                              fontWeight: FontWeight.w400,
                              textSize: 12.sp,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          await Navigator.pushNamed(
                            context,
                            AppRoutes.profileScreen,
                          );
                          mprofileProvider
                              .loadPrefs(); // Refresh after returning
                        },
                        icon: Image.asset(AppImages.edit, fit: BoxFit.contain),
                        iconSize: 35.w,
                        constraints: BoxConstraints(maxWidth: 35.w),
                      ),
                    ],
                  ),

                  SizedBox(height: 10.h),
                  const Divider(),

                  // _buildMenuItem(
                  //   AppStringsKey.subscriptionTitle,
                  //   AppImages.subscription,
                  //   AppRoutes.subscriptionHistory,
                  //   context,
                  //   ref,
                  // ),
                  _buildMenuItem(
                    translate(AppStringsKey.myAppointment),
                    AppImages.subscription,
                    AppRoutes.myappointments,
                    context,
                    ref,
                  ),
                  _buildMenuItem(
                    AppStringsKey.notificationTitle,
                    AppImages.notification,
                    AppRoutes.notificationScreen,
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
                  // _buildMenuItem(
                  //   AppStringsKey.helpSupportTitle,
                  //   AppImages.support,
                  //   '', // No navigation
                  //   context,
                  //   ref,
                  // ),
                  _buildMenuItem(
                    AppStringsKey.logout,
                    AppImages.logout,
                    'logout',
                    context,
                    ref,
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            // Footer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: InkWell(
                    onTap: () {},
                    child: AppText(
                      translate(AppStringsKey.privacyPolicy),

                      fontWeight: FontWeight.w500,
                      textSize: 12.sp,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: SizedBox(
                    height: 16.h,
                    child: VerticalDivider(color: Colors.black54, thickness: 2),
                  ),
                ),
                Flexible(
                  child: InkWell(
                    onTap: () {},
                    child: AppText(
                      translate(AppStringsKey.termsofService),

                      fontWeight: FontWeight.w500,
                      textSize: 12.sp,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    String title,
    String imageUrl,
    String route,
    BuildContext context,
    WidgetRef ref,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: InkWell(
        onTap: () async {
          if (route == 'Change Language') {
            ChangeLanguage().showLanguageDialog(context, ref);
          } else if (route == 'logout') {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const LogoutDialog(),
            );
          } else if (route.isNotEmpty) {
            await Navigator.pushNamed(context, route).then((_) {
              ref.read(profileProvider).loadPrefs();
            });
          }
        },
        child: SizedBox(
          height: 45.h,
          child: Row(
            children: [
              Image.asset(
                imageUrl,
                height: 22.h,
                width: 22.w,
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

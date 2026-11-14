import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:resize/resize.dart';
import 'package:user/constants/app_colors.dart';
import 'package:user/constants/app_strings.dart';
import 'package:user/di/di.dart';
import 'package:user/widgets/app_button.dart';
import 'package:user/widgets/app_text.dart';

class LogoutDialog extends ConsumerWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var mProfileProvider = ref.read(profileProvider);
    return Dialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0.r)),
      child: Padding(
        padding: EdgeInsets.only(
          left: 16.w,
          right: 16.w,
          top: 16.h,
          bottom: 16.h,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                translate(AppStringsKey.signOut),
                textSize: 16.sp,
                textColor: AppColors.secondary,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(height: 20.h),
              AppText(
                translate(AppStringsKey.areYouSure),
                textColor: AppColors.fontGreyColor,
                textSize: 12.sp,
              ),
              SizedBox(height: 30.h),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: AppPrimaryButton(
                      backgroundColor: AppColors.tabDividerGrey,
                      text: translate(AppStringsKey.no),
                      textSize: 14.sp,
                      textColor: AppColors.secondary,
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  SizedBox(width: 20.w),
                  Expanded(
                    child: AppPrimaryButton(
                      text: translate(AppStringsKey.yes),
                      textSize: 14.sp,
                      showLoader: false,
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).pop();
                        mProfileProvider.userSignOut();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/config/app_routes.dart';
import 'package:provider/constants/app_colors.dart';
import 'package:provider/constants/app_strings.dart';
import 'package:provider/di/di.dart';
import 'package:provider/main.dart';
import 'package:provider/widgets/app_button.dart';
import 'package:provider/widgets/app_text.dart';
import 'package:resize/resize.dart';

class LogoutDialog extends ConsumerWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mauthProvider = ref.watch(authProvider);

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
                      onTap: () {
                        Navigator.pop(context);
                        ref.read(profileProvider).userSignOut(context);
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

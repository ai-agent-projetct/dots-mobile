import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:resize/resize.dart';
import 'package:user/constants/app_colors.dart';
import 'package:user/constants/app_constants.dart';
import 'package:user/constants/app_images.dart';
import 'package:user/constants/app_strings.dart';
import 'package:user/features/subscriptions/presentation/widgets/add_subscription_dialog.dart';
import 'package:user/main.dart';
import 'package:user/widgets/app_bar.dart';
import 'package:user/widgets/app_text.dart';

class SubscriptionHistory extends ConsumerStatefulWidget {
  const SubscriptionHistory({super.key});

  @override
  SubscriptionHistoryState createState() => SubscriptionHistoryState();
}

class SubscriptionHistoryState extends ConsumerState<SubscriptionHistory> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        debugPrint('pop scope called from subscription screen ---- $didPop');
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SizedBox(
              //   height: AppConstants.safeAreaHeight,
              // ),
              CustomAppBar(
                title: translate(AppStringsKey.mySubscription),
                leadingIconHeight: 22.5.h,
                textSize: 16.sp,
                showLeadingIcon: true,
                leadingIconEnabled: true,
                onTap: () {
                  Navigator.of(context).pop();
                },
                options: InkWell(
                  onTap: () {
                    showDialog(
                      barrierDismissible: false,
                      context: navigatorKey.currentState!.context,
                      builder:
                          (BuildContext context) =>
                              const AddSubscriptionDialog(),
                    );
                  },
                  child: AppText(
                    '+Add New',
                    textColor: AppColors.primary,
                    textSize: 14.sp,
                    textDecoration: TextDecoration.underline,
                    lineHeight: 0.5,
                    decorationColor: AppColors.primary,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      'Current Plan',
                      textColor: AppColors.secondary,
                      textSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    SizedBox(height: 10.h),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(5.r),
                        border: Border.all(
                          width: 1.w,
                          color: AppColors.greyStroke,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 6.h,
                          horizontal: 6.h,
                        ),
                        child: IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(3.r),
                                  ),
                                  child: Image.asset(
                                    AppImages.appLogo,
                                    fit: BoxFit.cover,
                                    width: 25.vw,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10.h),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppText(
                                        '5 Months Plan',
                                        textSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 3.h),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          AppText(
                                            'Expires on:',
                                            textColor: AppColors.fontGreyColor
                                                .withValues(alpha: 1),
                                            textSize: 11.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          SizedBox(width: 5.w),
                                          AppText(
                                            '24th Jan, 2025',
                                            textColor: AppColors.fontGreyColor
                                                .withValues(alpha: 1),
                                            textSize: 11.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 3.h),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          AppText(
                                            'Status:',
                                            textColor: AppColors.fontGreyColor
                                                .withValues(alpha: 1),
                                            textSize: 11.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          SizedBox(width: 5.w),
                                          AppText(
                                            'Active',
                                            textColor: AppColors.oliveGreen
                                                .withValues(alpha: 1),
                                            textSize: 11.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.w,
                                  ),
                                  child: Container(
                                    width: 20.w,
                                    height: 20.h,
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
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
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/constants/app_colors.dart';
import 'package:provider/constants/app_images.dart';
import 'package:provider/constants/app_strings.dart';
import 'package:provider/di/di.dart';
import 'package:provider/features/subscription/data/model/getsubscripions_response_model.dart';
import 'package:provider/features/subscription/presentaion/widgets/addsubscription_dialog.dart';
import 'package:provider/main.dart';
import 'package:provider/widgets/app_bar.dart';
import 'package:provider/widgets/app_text.dart';
import 'package:provider/widgets/loading_widget.dart';
import 'package:provider/widgets/show_snackbar.dart';
import 'package:resize/resize.dart';

class SubscriptionScreen extends ConsumerStatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  SubscriptionScreenState createState() => SubscriptionScreenState();
}

class SubscriptionScreenState extends ConsumerState<SubscriptionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(subscriptionProvider).getSubsriptions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final mSubscriptionProvider = ref.watch(subscriptionProvider);

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
              CustomAppBar(
                title: translate(AppStringsKey.mySubscription),
                leadingIconHeight: 22.5.h,
                textSize: 16.sp,
                showLeadingIcon: true,
                leadingIconEnabled: true,
                onTap: () {
                  ref.read(homeProvider).onItemTap(1);
                },
                options: InkWell(
                  onTap: () async {
                    try {
                      final result = await showDialog(
                        barrierDismissible: false,
                        context: navigatorKey.currentState!.context,
                        builder:
                            (BuildContext context) =>
                                const AddSubscriptionDialog(),
                      );

                      if (result == true) {
                        ref.read(subscriptionProvider).getSubsriptions();
                      }
                    } catch (e) {
                      showSnackBar(message: "Error: $e");
                    }
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

              Expanded(
                child: Builder(
                  builder: (context) {
                    if (mSubscriptionProvider.isLoading &&
                        mSubscriptionProvider.allsubscriptions.isEmpty) {
                      return Center(child: LoadingWidget());
                    }
                    if (mSubscriptionProvider.errorMessage != null) {
                      return Center(
                        child: Text(
                          mSubscriptionProvider.errorMessage!,
                          // 'Something went wrong.',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.red,
                          ),
                        ),
                      );
                    }
                    if (mSubscriptionProvider.allsubscriptions.isEmpty) {
                      return Center(
                        child: Text(
                          "No Subscriptions found",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 10.h,
                      ),
                      itemCount: mSubscriptionProvider.allsubscriptions.length,
                      itemBuilder: (context, index) {
                        final GetSubscriptionData subscription =
                            mSubscriptionProvider.allsubscriptions[index];

                        return Padding(
                          padding: EdgeInsets.only(bottom: 10.h),
                          child: Container(
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
                                        padding: EdgeInsets.symmetric(
                                          vertical: 10.h,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            AppText(
                                              "${subscription.duration} Months Plan",
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
                                                  textColor: AppColors
                                                      .fontGreyColor
                                                      .withValues(alpha: 1),
                                                  textSize: 11.sp,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                SizedBox(width: 5.w),
                                                AppText(
                                                  subscription.expiryDate !=
                                                          null
                                                      ? subscription.expiryDate!
                                                          .split('T')
                                                          .first
                                                      : "-",
                                                  textColor: AppColors
                                                      .fontGreyColor
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
                                                  textColor: AppColors
                                                      .fontGreyColor
                                                      .withValues(alpha: 1),
                                                  textSize: 11.sp,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                SizedBox(width: 5.w),
                                                AppText(
                                                  subscription
                                                      .subscriptionStatus!,
                                                  textColor:
                                                      subscription.subscriptionStatus ==
                                                              'active'
                                                          ? AppColors.oliveGreen
                                                              .withValues(
                                                                alpha: 1,
                                                              )
                                                          : Colors.red,
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
                                            color:
                                                subscription.subscriptionStatus ==
                                                        'active'
                                                    ? Colors.green
                                                    : Colors.grey,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
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
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

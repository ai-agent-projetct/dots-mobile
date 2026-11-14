import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/constants/app_colors.dart';

import 'package:provider/di/di.dart';
import 'package:provider/utils/helpers/common_utils.dart';
import 'package:provider/widgets/app_button.dart';
import 'package:provider/widgets/app_text.dart';
import 'package:provider/widgets/app_text_field.dart';
import 'package:provider/widgets/common_widgets.dart';

import 'package:resize/resize.dart';

class AddSubscriptionDialog extends ConsumerStatefulWidget {
  final String? loginKey;
  const AddSubscriptionDialog({super.key, this.loginKey});

  @override
  AddSubscriptionDialogState createState() => AddSubscriptionDialogState();
}

class AddSubscriptionDialogState extends ConsumerState<AddSubscriptionDialog> {
  int? selectedIndex;
  int paymentMode = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(subscriptionProvider).getProviderSubsriptions();
      ref.read(subscriptionProvider).setupRazorpayListeners();
    });
  }

  @override
  Widget build(BuildContext context) {
    final subscriptionList = ref.watch(subscriptionProvider).subscriptions;
    final msubscriptionprovider = ref.watch(subscriptionProvider);

    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 10.w),
      backgroundColor: Colors.white,
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5.0.r)),
      ),
      actionsPadding: EdgeInsets.only(bottom: 15.h, right: 15.w, left: 15.w),
      actionsAlignment: MainAxisAlignment.end,
      titlePadding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),

      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText(
            widget.loginKey == null ? 'New Plan' : 'Confirm Subscription',
            textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.sp),
          ),

          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            alignment: Alignment.centerRight,
            icon: const Icon(Icons.close),
            padding: EdgeInsets.zero,
            visualDensity: const VisualDensity(
              horizontal: -4.0,
              vertical: -4.0,
            ),
          ),
        ],
      ),

      content: SingleChildScrollView(
        child: SizedBox(
          width: ResizeUtil().screenWidth,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              horizontalSeparatorWidget(),

              /// Subscription Plans Grid
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                child: MasonryGridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  itemCount: subscriptionList.length,
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  itemBuilder: (context, index) {
                    final sub = subscriptionList[index];
                    bool isSelected = selectedIndex == index;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                        debugPrint(
                          "Selected Subscription ID: ${sub.subscriptionId}",
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.backGroundGrey.withValues(
                            alpha: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(5.r),
                          border: Border.all(
                            width: 1.w,
                            color: AppColors.greyStroke,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 10.h,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                      sub.name,
                                      textSize: 12.sp,
                                      textColor: AppColors.secondary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    AppText(
                                      "${sub.duration} Months | ₹ ${double.parse(sub.amount).toInt()}",
                                      textColor: AppColors.fontGreyColor
                                          .withValues(alpha: 0.6),
                                      textSize: 11.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ],
                                ),
                              ),

                              /// Tick Mark
                              Container(
                                width: 20.w,
                                height: 20.h,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      isSelected
                                          ? AppColors.primary
                                          : Colors.transparent,
                                  border: Border.all(
                                    color:
                                        isSelected
                                            ? AppColors.primary
                                            : AppColors.greyStroke,
                                    width: 2.w,
                                  ),
                                ),
                                child:
                                    isSelected
                                        ? Icon(
                                          Icons.check,
                                          size: 14.w,
                                          color: Colors.white,
                                        )
                                        : null,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              /// Payment Mode
              Row(
                children: [
                  Radio<int>(
                    value: 0,
                    groupValue: paymentMode,
                    activeColor: AppColors.primary,
                    onChanged: (val) {
                      setState(() {
                        paymentMode = val!;
                      });
                    },
                  ),
                  const Text("Online"),
                  SizedBox(width: 20.w),
                  Radio<int>(
                    value: 1,
                    groupValue: paymentMode,
                    activeColor: AppColors.primary,
                    onChanged: (val) {
                      setState(() {
                        msubscriptionprovider.marketingIdController.clear();
                        paymentMode = val!;
                      });
                    },
                  ),
                  const Text("Cash"),
                ],
              ),

              /// Marketing Executive ID
              if (paymentMode == 1)
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 15.w,
                    vertical: 10.h,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: PrimaryTextField(
                      msubscriptionprovider.marketingIdController,
                      hint: "Enter Marketing Executive ID",
                      fillColor: AppColors.backGroundGrey.withValues(
                        alpha: 0.5,
                      ),
                      inputFormatter: [NoLeadingSpaceFormatter()],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),

      /// Subscribe Button
      actions: [
        // AppPrimaryButton(
        //   text: 'Submit',
        //   textSize: 16.sp,
        //   showLoader: msubscriptionprovider.isLoading,
        //   onTap: () async {
        //     if (selectedIndex != null) {
        //       final selectedSubscription = subscriptionList[selectedIndex!];
        //       log(selectedSubscription.subscriptionId);
        //       msubscriptionprovider.createSubscription(
        //         selectedSubscription.subscriptionId,
        //       );

        //       Navigator.of(context).pop();
        //     } else {
        //       CommonUtils.showToast("Choose a subscription plan");
        //     }
        //   },
        // ),
        AppPrimaryButton(
          text: 'Submit',
          textSize: 16.sp,
          showLoader:
              msubscriptionprovider.isLoading, // show loader from provider
          onTap: () async {
            CommonUtils.hideKeyBoard(context);
            if (selectedIndex != null) {
              final selectedSubscription = subscriptionList[selectedIndex!];

              if (paymentMode == 1) {
                // CASH Mode
                if (msubscriptionprovider.marketingIdController.text
                    .trim()
                    .isEmpty) {
                  CommonUtils.showToast("Please enter Marketing Executive ID");
                  return;
                }

                await msubscriptionprovider.addCashSubscription(
                  selectedSubscription.subscriptionId,
                );
                Navigator.of(context).pop();
              } else {
                // ONLINE Mode

                final success = await msubscriptionprovider.createSubscription(
                  selectedSubscription.subscriptionId,
                );
                if (success && context.mounted) {
                  Navigator.pop(context, true);
                }
              }
            } else {
              CommonUtils.showToast("Choose a subscription plan");
            }
          },
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:resize/resize.dart';
import 'package:user/constants/app_colors.dart';
import 'package:user/constants/app_constants.dart';
import 'package:user/constants/app_strings.dart';
import 'package:user/di/di.dart';
import 'package:user/utils/helpers/common_utils.dart';
import 'package:user/utils/services/prefs.dart';
import 'package:user/widgets/app_button.dart';
import 'package:user/widgets/app_text.dart';
import 'package:user/widgets/common_widgets.dart';
import 'package:user/widgets/loading_widget.dart';
import 'package:user/widgets/show_snackbar.dart';

class AddSubscriptionDialog extends ConsumerStatefulWidget {
  const AddSubscriptionDialog({super.key});

  @override
  AddSubscriptionDialogState createState() => AddSubscriptionDialogState();
}

class AddSubscriptionDialogState extends ConsumerState<AddSubscriptionDialog> {
  int? selectedIndex;
  final Razorpay razorpay = Razorpay();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(subscriptionProvider).getUserSubsriptions();
      // ref.read(subscriptionProvider).setupRazorpayListeners();
    });
  }

  @override
  Widget build(BuildContext context) {
    final subscriptionList = ref.watch(subscriptionProvider).subscriptions;
    final msubscriptionprovider = ref.watch(subscriptionProvider);
    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 15.w),
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
          const AppText(
            'New Plan',
            textColor: AppColors.secondary,
            fontWeight: FontWeight.w600,
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            alignment: Alignment.centerRight,
            icon: Icon(Icons.close),
            padding: EdgeInsets.zero,
            visualDensity: VisualDensity(horizontal: -4.0, vertical: -4.0),
          ),
        ],
      ),
      content: SizedBox(
        width: ResizeUtil().screenWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            horizontalSeparatorWidget(),

            /// Subscription Plans Grid
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
              child: Builder(
                builder: (context) {
                  if (msubscriptionprovider.isLoading &&
                      subscriptionList.isEmpty) {
                    return Center(child: LoadingWidget());
                  }
                  if (msubscriptionprovider.errorMessage != null) {
                    return Center(
                      child: Text(
                        // mSubscriptionProvider.errorMessage!,
                        'Something went wrong.',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.red,
                        ),
                      ),
                    );
                  }
                  if (msubscriptionprovider.subscriptions.isEmpty) {
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
                  return MasonryGridView.count(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        AppPrimaryButton(
          text: 'Subscribe',
          textSize: 16.sp,
          onTap: () {
            if (selectedIndex != null) {
              Navigator.of(context).pop();
            } else {
              CommonUtils.showToast("Choose either one of the subscription");
            }
          },
        ),
      ],
    );
  }
}

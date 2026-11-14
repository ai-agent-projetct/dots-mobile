import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:resize/resize.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user/constants/app_colors.dart';
import 'package:user/di/di.dart';
import 'package:user/utils/services/prefs.dart';
import 'package:user/widgets/app_text.dart';
import 'package:user/widgets/app_text_field.dart';
import 'package:user/widgets/loading_widget.dart';
import 'package:user/widgets/profilecircular.dart';

class TradePostDialog extends ConsumerWidget {
  const TradePostDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trade = ref.watch(tradeProvider);
    final userName = Prefs().getString(Prefs.fullName);
    final profileImage = Prefs().getString(Prefs.userImage);

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        trade.clearControllers();
      },
      child: Dialog(
        backgroundColor: AppColors.white,
        insetPadding: EdgeInsets.symmetric(horizontal: 15.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0.r),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: 16.0.w,
            right: 16.w,
            top: 16.0.h,
            bottom: 16.0.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  ProfileCircleAvatar(radius: 20.w, imageUrl: profileImage),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      userName ?? "User",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10.h),

              PrimaryTextField(
                trade.descriptionController,
                maxLines: null,
                hint: "Add a description",
                fillColor: AppColors.white,
                minline: 4,
                maxLength: 255,
                inputFormatter: [NoLeadingSpaceFormatter()],
              ),

              SizedBox(height: 10.h),

              if (trade.pikedImage != null)
                Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 10.h),
                      height: 150.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        image: DecorationImage(
                          image: FileImage(trade.pikedImage!),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: IconButton(
                        icon: Icon(Icons.cancel, color: Colors.red),
                        onPressed: () => trade.clearImage(),
                      ),
                    ),
                  ],
                ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (trade.pikedImage == null)
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.image,
                            size: 30,
                            color: Colors.green,
                          ),
                          onPressed:
                              () => ref.read(tradeProvider).pickFromGallery(),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.camera_alt,
                            size: 30,
                            color: Colors.blue,
                          ),
                          onPressed:
                              () => ref.read(tradeProvider).pickFromCamera(),
                        ),
                      ],
                    ),
                  Spacer(),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.bottomNavigationIconColor,
                        foregroundColor: AppColors.backGroundGrey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 5.h,
                        ),
                      ),

                      onPressed:
                          trade.isLoading
                              ? null
                              : () async {
                                final success = await trade.uploadAndPostTrade(
                                  context,
                                );

                                if (success && context.mounted) {
                                  Navigator.pop(context, true);
                                }
                              },

                      child:
                          trade.isLoading
                              ? SizedBox(
                                height: 20,
                                width: 20,
                                child: LoadingIndicator(
                                  indicatorType: Indicator.ballPulse,
                                  colors: [AppColors.white],
                                  strokeWidth: 2,
                                  backgroundColor: Colors.transparent,
                                ),
                              )
                              : AppText("Post", textColor: AppColors.white),
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

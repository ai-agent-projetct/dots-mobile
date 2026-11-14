import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/constants/app_colors.dart';
import 'package:provider/constants/app_strings.dart';
import 'package:provider/di/di.dart';
import 'package:provider/features/Trends/data/model/gettrends_responsemodel.dart';
import 'package:provider/utils/helpers/common_utils.dart';
import 'package:provider/utils/services/prefs.dart';
import 'package:provider/widgets/app_text_field.dart';

import 'package:provider/widgets/profilecircleavatar.dart';
import 'package:resize/resize.dart';

class TrendpostdialogWidget extends ConsumerStatefulWidget {
  final TrendItem? trend;
  const TrendpostdialogWidget({super.key, this.trend});

  @override
  ConsumerState<TrendpostdialogWidget> createState() =>
      _TrendpostdialogWidgetState();
}

class _TrendpostdialogWidgetState extends ConsumerState<TrendpostdialogWidget> {
  @override
  void initState() {
    super.initState();
    final mtrendsprovider = ref.read(trendsProvider);

    if (widget.trend != null) {
      mtrendsprovider.descriptionController.text =
          widget.trend!.description ?? '';
      mtrendsprovider.selectedImage = widget.trend!.mediaFile;
      localMediaFile = widget.trend!.mediaFile; // create a copy
    }
  }

  String? localMediaFile;
  @override
  Widget build(BuildContext context) {
    final mtrendsprovider = ref.watch(trendsProvider);
    final firstName = Prefs().getString(Prefs.firstName);
    final lastName = Prefs().getString(Prefs.lastName);
    log("$lastName");
    final profileImage = Prefs().getString(Prefs.profileImage);

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        mtrendsprovider.clearControllers();
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
                      lastName != null && lastName.isNotEmpty
                          ? '$firstName $lastName'
                          : '$firstName',
                      style: TextStyle(
                        fontFamily: AppStringsKey.poppins,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (widget.trend != null)
                    ElevatedButton(
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
                          mtrendsprovider.isLoading
                              ? null
                              : () async {
                                CommonUtils.hideKeyBoard(context);

                                final oldDescription =
                                    widget.trend?.description ?? '';
                                final oldImage = widget.trend?.mediaFile ?? '';

                                final newDescription =
                                    mtrendsprovider.descriptionController.text
                                        .trim();
                                final newImage =
                                    mtrendsprovider.pikedImage != null
                                        ? 'new-image-selected'
                                        : mtrendsprovider.selectedImage ?? '';

                                if (newDescription.isEmpty &&
                                    (newImage.isEmpty ||
                                        mtrendsprovider.isImageRemoved)) {
                                  CommonUtils.showToast(
                                    "Description and image cannot both be empty",
                                  );
                                  return;
                                }

                                if (newDescription == oldDescription &&
                                    newImage == oldImage &&
                                    !mtrendsprovider.isImageRemoved) {
                                  CommonUtils.showToast("No changes to update");
                                  return;
                                }

                                if (mtrendsprovider.isImageRemoved &&
                                    mtrendsprovider.pikedImage == null) {
                                  CommonUtils.showToast(
                                    "Please select an image",
                                  );
                                  return;
                                }

                                if (newDescription.isEmpty) {
                                  CommonUtils.showToast(
                                    "Please enter a description",
                                  );
                                  return;
                                }
                                if ((newImage.isEmpty ||
                                        mtrendsprovider.isImageRemoved) &&
                                    mtrendsprovider.pikedImage == null) {
                                  CommonUtils.showToast(
                                    "Please select an image",
                                  );
                                  return;
                                }

                                // ✅ Call API
                                final success = await mtrendsprovider
                                    .updateTrends(
                                      "Update",
                                      widget.trend!.mediaId,
                                      context,
                                    );

                                if (success && context.mounted) {
                                  Navigator.pop(
                                    context,
                                    true,
                                  ); // trigger refresh
                                }
                              },

                      child:
                          mtrendsprovider.isLoading
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
                              : const Text("Save"),
                    ),

                  // AppPrimaryButton(text: text, onTap: onTap)
                ],
              ),
              SizedBox(height: 10.h),

              PrimaryTextField(
                mtrendsprovider.descriptionController,
                maxLines: null,
                hint: "Add a description",
                fillColor: AppColors.white,
                minline: 4,
                maxLength: 255,
                inputFormatter: [NoLeadingSpaceFormatter()],
              ),

              SizedBox(height: 10.h),

              // if (mtrendsprovider.pikedImage != null ||
              //     (widget.trend != null && widget.trend!.mediaFile != null))
              //   Stack(
              //     children: [
              //       Container(
              //         margin: EdgeInsets.only(bottom: 10.h),
              //         height: 150.h,
              //         width: double.infinity,
              //         decoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(10.r),
              //           image: DecorationImage(
              //             image:
              //                 // mtrendsprovider.pikedImage != null
              //                 //     ? FileImage(mtrendsprovider.pikedImage!)
              //                 //         as ImageProvider
              //                 //     : CachedNetworkImageProvider(
              //                 //       widget.trend!.mediaFile!,
              //                 //     ),
              //                 mtrendsprovider.pikedImage != null
              //                     ? FileImage(mtrendsprovider.pikedImage!)
              //                     : CachedNetworkImageProvider(
              //                       localMediaFile ?? '',
              //                     ),
              //             fit: BoxFit.contain,
              //           ),
              //         ),
              //       ),
              //       Positioned(
              //         top: 4,
              //         right: 4,
              //         child: IconButton(
              //           icon: Icon(Icons.cancel, color: Colors.black),
              //           onPressed: () {
              //             if (mtrendsprovider.pikedImage != null) {
              //               mtrendsprovider.clearImage();
              //             } else {
              //               mtrendsprovider.selectedImage = null;
              //               mtrendsprovider.isImageRemoved = true;
              //               // widget.trend!.mediaFile = null;
              //               localMediaFile = null; // change only local copy
              //               setState(() {});
              //             }
              //           },
              //         ),
              //       ),
              //     ],
              //   ),
              if (mtrendsprovider.pikedImage != null ||
                  (localMediaFile != null && localMediaFile!.isNotEmpty))
                Stack(
                  children: [
                    Container(
                      height: 150.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image:
                              mtrendsprovider.pikedImage != null
                                  ? FileImage(mtrendsprovider.pikedImage!)
                                  : CachedNetworkImageProvider(localMediaFile!),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        icon: Icon(Icons.cancel, color: Colors.black),
                        onPressed: () {
                          if (mtrendsprovider.pikedImage != null) {
                            mtrendsprovider.clearImage();
                          } else {
                            mtrendsprovider.selectedImage = null;
                            mtrendsprovider.isImageRemoved = true;
                            localMediaFile = null; // only local change
                            setState(() {});
                          }
                        },
                      ),
                    ),
                  ],
                ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (mtrendsprovider.pikedImage == null)
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.image,
                            size: 30,
                            color: Colors.green,
                          ),
                          onPressed:
                              () => ref.read(trendsProvider).pickFromGallery(),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.camera_alt,
                            size: 30,
                            color: Colors.blue,
                          ),
                          onPressed:
                              () => ref.read(trendsProvider).pickFromCamera(),
                        ),
                      ],
                    ),
                  Spacer(),
                  // mtrendsprovider.isLoading
                  //     ? LoadingWidget()
                  //     :
                  if (widget.trend == null)
                    ElevatedButton(
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
                          mtrendsprovider.isLoading
                              ? null
                              : () async {
                                final success = await mtrendsprovider
                                    .uploadAndPostTrend(context);
                                if (success && context.mounted) {
                                  Navigator.pop(context, true);
                                }
                              },

                      child:
                          mtrendsprovider.isLoading
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
                              : Text("Post"),
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

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:resize/resize.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:user/config/app_routes.dart';
import 'package:user/constants/app_colors.dart';
import 'package:user/constants/app_constants.dart';
import 'package:user/constants/app_images.dart';
import 'package:user/constants/app_strings.dart';
import 'package:user/di/di.dart';
import 'package:user/features/serviceProvider/data/models/providers_list_model.dart';
import 'package:user/features/serviceProvider/presentation/provider/jobbers_provider.dart';
import 'package:user/features/serviceProvider/presentation/widgets/review_details.dart';
import 'package:user/utils/helpers/common_utils.dart';
import 'package:user/utils/helpers/extension.dart';
import 'package:user/widgets/app_bar.dart';
import 'package:user/widgets/app_button.dart';
import 'package:user/widgets/app_text.dart';
import 'package:user/widgets/app_text_field.dart';
import 'package:user/widgets/common_widgets.dart';
import 'package:user/widgets/loading_widget.dart';
import 'package:user/widgets/profilecircular.dart';

class ProviderDetailsScreen extends ConsumerStatefulWidget {
  const ProviderDetailsScreen({super.key, this.providerId, this.subcategoryId});

  final String? providerId;
  final String? subcategoryId;

  @override
  ProviderDetailsScreenState createState() => ProviderDetailsScreenState();
}

class ProviderDetailsScreenState extends ConsumerState<ProviderDetailsScreen> {
  late JobbersProvider mJobbersProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint('Provider id ---> ${widget.providerId}');
      if (widget.providerId.toString() != 'null') {
        mJobbersProvider.getServiceProviderDetails(
          widget.providerId.toString(),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    mJobbersProvider = ref.watch(jobbersProvider);
    final worksList = mJobbersProvider.providerDetailsData?.works ?? [];

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        debugPrint(
          'pop scope called from provider details screen ---- $didPop',
        );
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SizedBox(height: AppConstants.safeAreaHeight),
              CustomAppBar(
                title: translate(AppStringsKey.providerProfile),
                leadingIconHeight: 22.5.h,
                textSize: 16.sp,
                showLeadingIcon: true,
                leadingIconEnabled: true,
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 5.h,
                  ),
                  child:
                      mJobbersProvider.isLoading
                          ? LoadingWidget()
                          : mJobbersProvider.providerDetailsData == null
                          ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: AppText(
                                  'No provider details available',
                                  textSize: 14.sp,
                                  textAlign: TextAlign.center,
                                  textColor: AppColors.grey,
                                ),
                              ),
                            ],
                          )
                          : SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                IntrinsicHeight(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Profile Picture
                                      Container(
                                        height: 40.h,
                                        width: 40.w,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                        child: ProfileCircleAvatar(
                                          imageUrl:
                                              mJobbersProvider
                                                  .providerDetailsData!
                                                  .profileImage,
                                          radius: 20,
                                        ),
                                      ),
                                      SizedBox(width: 10.w),

                                      // Main Info
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Name and Rating Row
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: AppText(
                                                    '${mJobbersProvider.providerDetailsData!.firstName.toString().capitalize()} ${mJobbersProvider.providerDetailsData!.lastName.toString().capitalize()}',
                                                    textSize: 14.sp,
                                                    fontWeight: FontWeight.w500,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                SizedBox(width: 6.w),
                                                GestureDetector(
                                                  onTap: () {
                                                    log(
                                                      "review  for :${mJobbersProvider.providerDetailsData!.providerID}  ${mJobbersProvider.providerDetailsData!.firstName} ${mJobbersProvider.providerDetailsData!.lastName}",
                                                    );
                                                    showModalBottomSheet(
                                                      context: context,
                                                      isScrollControlled: true,
                                                      backgroundColor:
                                                          AppColors.white,
                                                      shape: const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.vertical(
                                                              top:
                                                                  Radius.circular(
                                                                    20,
                                                                  ),
                                                            ),
                                                      ),
                                                      builder:
                                                          (context) =>
                                                              const ReviewBottomSheet(),
                                                    );
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Image.asset(
                                                        AppImages
                                                            .starUnfilledIcon,
                                                        color:
                                                            Colors
                                                                .lime
                                                                .shade600,
                                                        height: 15.h,
                                                        width: 15.w,
                                                      ),
                                                      SizedBox(width: 3.w),
                                                      AppText(
                                                        mJobbersProvider
                                                            .ratingData!
                                                            .formattedAverage
                                                            .toString(),

                                                        textColor: AppColors
                                                            .fontGreyColor
                                                            .withOpacity(0.7),
                                                        textSize: 12.sp,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),

                                            SizedBox(height: 3.h),

                                            // Address
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  Icons.location_on,
                                                  color: Colors.red,
                                                  size: 20.sp,
                                                ),
                                                SizedBox(width: 5.w),
                                                Expanded(
                                                  child: AppText(
                                                    mJobbersProvider
                                                        .providerDetailsData!
                                                        .address,
                                                    textColor:
                                                        AppColors.fontGreyColor,
                                                    textSize: 11.sp,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),

                                            SizedBox(height: 6.h),

                                            // Book Appointment and Call Row
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                // Book Appointment Button
                                                ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 30,
                                                        ),
                                                    backgroundColor:
                                                        AppColors.primary,
                                                    elevation: 0,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            5,
                                                          ),
                                                      side: BorderSide(
                                                        color:
                                                            AppColors
                                                                .greyBorder,
                                                      ),
                                                    ),
                                                    foregroundColor:
                                                        AppColors.white,
                                                  ),
                                                  onPressed: () async {
                                                    final details =
                                                        mJobbersProvider
                                                            .providerDetailsData!;
                                                    final providerData = ProvidersData(
                                                      id: details.id,
                                                      providerID:
                                                          details.providerID,
                                                      proID: details.proID,
                                                      roleId: details.roleId,
                                                      firstName:
                                                          details.firstName,
                                                      lastName:
                                                          details.lastName,
                                                      emailAddress:
                                                          details.emailAddress,
                                                      phoneNumber:
                                                          details.phoneNumber,
                                                      address: details.address,
                                                      latitude:
                                                          details.latitude,
                                                      longitude:
                                                          details.longitude,
                                                      distance:
                                                          details.distance,
                                                      subCategoryResponseModel:
                                                          details
                                                                      .subCategoryResponseModel
                                                                      ?.isNotEmpty ==
                                                                  true
                                                              ? details
                                                                  .subCategoryResponseModel!
                                                                  .first
                                                              : null,
                                                    );

                                                    Navigator.pushNamed(
                                                      context,
                                                      AppRoutes
                                                          .bookAppointmentScreen,

                                                      //   arguments: providerData,
                                                      arguments: {
                                                        'providerData':
                                                            providerData,
                                                        'subCategoryId':
                                                            widget
                                                                .subcategoryId,
                                                      },
                                                    );
                                                  },
                                                  child: AppText(
                                                    'Book an Appointment',
                                                    textStyle: TextStyle(
                                                      fontFamily:
                                                          AppStringsKey.poppins,
                                                      fontSize: 8.sp,
                                                      color: AppColors.white,
                                                    ),
                                                  ),
                                                ),

                                                // Call Icon
                                                IconButton(
                                                  onPressed: () {
                                                    CommonUtils.checkCallPermission(
                                                      mJobbersProvider
                                                          .providerDetailsData!
                                                          .phoneNumber
                                                          .toString(),
                                                    );
                                                  },
                                                  icon: Image.asset(
                                                    AppImages.callIcon,
                                                    color: AppColors.primary,
                                                    height: 20.h,
                                                    width: 20.w,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10.h),
                                  child: horizontalSeparatorWidget(),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                      translate(AppStringsKey.aboutTitle),
                                      textSize: 15.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    SizedBox(height: 10.h),
                                    mJobbersProvider
                                                .providerDetailsData!
                                                .description !=
                                            null
                                        ? AppText(
                                          mJobbersProvider
                                              .providerDetailsData!
                                              .description,
                                          textSize: 12.5.sp,
                                          textAlign: TextAlign.left,
                                          fontWeight: FontWeight.w400,
                                        )
                                        : Center(
                                          child: AppText(
                                            "No data available",
                                            textColor: Colors.grey,
                                            textSize: 12.sp,
                                          ),
                                        ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10.h),
                                  child: horizontalSeparatorWidget(),
                                ),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                      translate(AppStringsKey.workTitle),
                                      textSize: 15.sp,
                                      fontWeight: FontWeight.w500,
                                    ),

                                    if (worksList.isEmpty)
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 10.h,
                                        ),
                                        child: Center(
                                          child: AppText(
                                            "No works available",
                                            textColor: Colors.grey,
                                            textSize: 12.sp,
                                          ),
                                        ),
                                      )
                                    else
                                      GridView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        padding: EdgeInsets.symmetric(
                                          vertical: 10.h,
                                        ),
                                        itemCount:
                                            mJobbersProvider.showAllImages
                                                ? worksList.length
                                                : (worksList.length > 6
                                                    ? 6
                                                    : worksList.length),
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 3,
                                              crossAxisSpacing: 8,
                                              mainAxisSpacing: 8,
                                            ),
                                        itemBuilder: (context, index) {
                                          // "Show more" overlay on 6th item when not showing all
                                          if (!mJobbersProvider.showAllImages &&
                                              index == 5 &&
                                              worksList.length > 6) {
                                            return GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  mJobbersProvider
                                                      .showAllImages = true;
                                                });
                                              },
                                              child: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  _buildWorkImage(
                                                    worksList[index].mediaUrl,
                                                  ),
                                                  Container(
                                                    color: Colors.black45,
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "+ ${worksList.length - 6}",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20.sp,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }

                                          // Normal image item
                                          return _buildWorkImage(
                                            worksList[index].mediaUrl,
                                          );
                                        },
                                      ),

                                    if (mJobbersProvider.showAllImages &&
                                        worksList.length > 6)
                                      Align(
                                        alignment: Alignment.center,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              mJobbersProvider.showAllImages =
                                                  false;
                                            });
                                          },
                                          child: AppText(
                                            "Show Less",
                                            textColor: AppColors.white,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10.h),
                                  child: horizontalSeparatorWidget(),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                      translate(AppStringsKey.reviewsTitle),
                                      textSize: 15.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    SizedBox(height: 10.h),
                                    if (mJobbersProvider.ratingData?.reviews !=
                                            null &&
                                        mJobbersProvider
                                            .ratingData!
                                            .reviews
                                            .isNotEmpty)
                                      Column(
                                        children: [
                                          SizedBox(
                                            height: 100.h,
                                            child: PageView.builder(
                                              controller:
                                                  mJobbersProvider
                                                      .reviewPageController,
                                              itemCount:
                                                  mJobbersProvider
                                                      .ratingData!
                                                      .reviews
                                                      .length,
                                              itemBuilder: (
                                                context,
                                                reviewIndex,
                                              ) {
                                                final review =
                                                    mJobbersProvider
                                                        .ratingData!
                                                        .reviews[reviewIndex];
                                                return ReviewDetails(
                                                  review: review,
                                                );
                                              },
                                            ),
                                          ),
                                          SizedBox(height: 10.h),
                                          SmoothPageIndicator(
                                            controller:
                                                mJobbersProvider
                                                    .reviewPageController,
                                            count:
                                                mJobbersProvider
                                                    .ratingData!
                                                    .reviews
                                                    .length,
                                            effect: ExpandingDotsEffect(
                                              expansionFactor: 2,
                                              dotHeight: 5.h,
                                              dotWidth: 5.w,
                                              spacing: 2.0.w,
                                              activeDotColor: AppColors.primary,
                                              dotColor: AppColors.hintTextGrey,
                                            ),
                                          ),
                                        ],
                                      )
                                    else
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 10.h,
                                        ),
                                        child: Center(
                                          child: AppText(
                                            "No reviews yet",
                                            textColor: Colors.grey,
                                            textSize: 12.sp,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                SizedBox(height: 30.h),
                              ],
                            ),
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Helper widget for work images with shimmer + error
Widget _buildWorkImage(String? url) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(3.r),
    child: Image.network(
      url ?? "",
      fit: BoxFit.cover,
      width: 25.vw,
      height: 60.h,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(width: 25.vw, height: 60.h, color: Colors.white),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: 25.vw,
          height: 60.h,
          color: Colors.grey.shade200,
          alignment: Alignment.center,
          child: Icon(Icons.broken_image, color: Colors.grey, size: 20.sp),
        );
      },
    ),
  );
}

class ReviewBottomSheet extends ConsumerStatefulWidget {
  const ReviewBottomSheet({super.key});

  @override
  ConsumerState<ReviewBottomSheet> createState() => _ReviewBottomSheetState();
}

class _ReviewBottomSheetState extends ConsumerState<ReviewBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final mJobbersProvider = ref.watch(jobbersProvider);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Close Handle
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Center(
              child: Container(
                height: 5,
                width: 50,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),

          Text(
            "Rate and Review",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 12),

          // ⭐ Star Rating
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return IconButton(
                onPressed: () {
                  CommonUtils.hideKeyBoard(context);
                  setState(() => mJobbersProvider.rating = index + 1.0);
                },
                icon: Icon(
                  Icons.star,
                  size: 32,
                  color:
                      index < mJobbersProvider.rating
                          ? Colors.amber
                          : Colors.grey[300],
                ),
              );
            }),
          ),

          SizedBox(height: 12),

          // ✍ Review Field
          TextField(
            controller: mJobbersProvider.reviewtextController,
            maxLines: 4,
            maxLength: 255,
            maxLengthEnforcement:
                MaxLengthEnforcement.enforced, // Enforce limit
            cursorColor: AppColors.primary,
            style: TextStyle(
              fontSize: 12.sp,
              fontFamily: AppStringsKey.poppins,
            ),
            inputFormatters: [NoLeadingSpaceFormatter()],
            decoration: InputDecoration(
              hintText: "Write your review...",
              hintStyle: TextStyle(
                fontSize: 12.sp,
                fontFamily: AppStringsKey.poppins,
              ),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              counterText: "", // Hides the length counter in UI
            ),
            onChanged: (_) => setState(() {}),
          ),

          SizedBox(height: 20.h),

          // 📩 Submit Button
          SizedBox(
            width: double.infinity,
            child: AppPrimaryButton(
              text: "Submit",
              textSize: 14.sp,
              showLoader: mJobbersProvider.iscreateLoading,
              onTap: () {
                mJobbersProvider.handleSubmit(context);
              },
            ),
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}

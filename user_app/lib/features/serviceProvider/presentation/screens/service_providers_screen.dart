import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:resize/resize.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user/config/app_routes.dart';
import 'package:user/constants/app_colors.dart';
import 'package:user/constants/app_constants.dart';
import 'package:user/constants/app_images.dart';
import 'package:user/constants/app_strings.dart';
import 'package:user/di/di.dart';
import 'package:user/features/serviceProvider/presentation/provider/jobbers_provider.dart';
import 'package:user/utils/helpers/common_utils.dart';
import 'package:user/utils/helpers/extension.dart';
import 'package:user/widgets/app_bar.dart';
import 'package:user/widgets/app_button.dart';
import 'package:user/widgets/app_text.dart';
import 'package:user/widgets/loading_widget.dart';

class ServiceProvidersScreen extends ConsumerStatefulWidget {
  const ServiceProvidersScreen({super.key, this.subCatId});

  final String? subCatId;

  @override
  ServiceProvidersScreenState createState() => ServiceProvidersScreenState();
}

class ServiceProvidersScreenState
    extends ConsumerState<ServiceProvidersScreen> {
  late JobbersProvider mJobbersProvider;

  @override
  void initState() {
    super.initState();
    debugPrint('subCatId ---> ${widget.subCatId}');
    debugPrint('user latlng ---> ${ref.read(mapsProvider).currentLatLng}');
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (ref.read(mapsProvider).currentLatLng != LatLng(0, 0) &&
          widget.subCatId.toString() != 'null') {
        await mJobbersProvider.getServiceProvidersList(
          ref.read(mapsProvider).currentLatLng.latitude.toString(),
          ref.read(mapsProvider).currentLatLng.longitude.toString(),
          widget.subCatId.toString(),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    mJobbersProvider = ref.watch(jobbersProvider);

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        debugPrint('pop scope called from providers screen ---- $didPop');
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SizedBox(height: AppConstants.safeAreaHeight),
              CustomAppBar(
                title: translate(AppStringsKey.providersList),
                leadingIconHeight: 22.5.h,
                textSize: 16.sp,
                showLeadingIcon: true,
                leadingIconEnabled: true,
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              Expanded(
                child:
                    mJobbersProvider.isLoading
                        ? LoadingWidget()
                        : mJobbersProvider.providersList.isEmpty
                        ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppText(
                              'No service providers available in your location.',
                              textSize: 14.sp,
                              textAlign: TextAlign.center,
                              textColor: AppColors.grey,
                            ),
                          ],
                        )
                        : ListView.builder(
                          scrollDirection: Axis.vertical,
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 5.h,
                          ),
                          physics: ClampingScrollPhysics(),
                          itemCount: mJobbersProvider.providersList.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(3.r),
                                            ),
                                            child: Image.network(
                                              mJobbersProvider
                                                      .providersList[index]
                                                      .subCategoryResponseModel
                                                      ?.subCatImg ??
                                                  "", // Fallback if null
                                              fit: BoxFit.cover,
                                              width: 25.vw,
                                              loadingBuilder: (
                                                context,
                                                child,
                                                loadingProgress,
                                              ) {
                                                if (loadingProgress == null)
                                                  return child;
                                                // Show shimmer while loading
                                                return Shimmer.fromColors(
                                                  baseColor:
                                                      Colors.grey.shade300,
                                                  highlightColor:
                                                      Colors.grey.shade100,
                                                  child: Container(
                                                    width: 25.vw,
                                                    height: double.infinity,
                                                    color: Colors.white,
                                                  ),
                                                );
                                              },
                                              errorBuilder: (
                                                context,
                                                error,
                                                stackTrace,
                                              ) {
                                                // Show placeholder if error
                                                return Container(
                                                  width: 25.vw,
                                                  height: double.infinity,
                                                  color: Colors.grey.shade200,
                                                  alignment: Alignment.center,
                                                  child: Icon(
                                                    Icons.broken_image,
                                                    color: Colors.grey,
                                                    size: 20.sp,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          SizedBox(width: 10.w),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // SizedBox(height: 5.h),
                                                AppText(
                                                  "${mJobbersProvider.providersList[index].firstName!.toString().capitalize()} ${mJobbersProvider.providersList[index].lastName!.toString().capitalize()}",
                                                  textSize: 13.sp,
                                                  fontWeight: FontWeight.w600,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                SizedBox(height: 5.h),
                                                AppText(
                                                  mJobbersProvider
                                                      .providersList[index]
                                                      .subCategoryResponseModel!
                                                      .subCategoryName
                                                      .toString(),
                                                  textSize: 12.sp,
                                                  fontWeight: FontWeight.w500,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                SizedBox(height: 5.h),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                    left: 3.w,
                                                  ),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      ClipRRect(
                                                        child: Image.asset(
                                                          AppImages
                                                              .starUnfilledIcon,
                                                          color:
                                                              Colors
                                                                  .lime
                                                                  .shade600,
                                                          fit: BoxFit.cover,
                                                          height: 15.h,
                                                          width: 15.w,
                                                        ),
                                                      ),
                                                      SizedBox(width: 5.w),
                                                      Expanded(
                                                        child: AppText(
                                                          mJobbersProvider
                                                              .providersList[index]
                                                              .formattedAverage,
                                                          textColor: AppColors
                                                              .fontGreyColor
                                                              .withValues(
                                                                alpha: 0.7,
                                                              ),
                                                          textSize: 10.sp,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 30,
                                                            // vertical: 10,
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
                                                    onPressed: () {
                                                      final provider =
                                                          mJobbersProvider
                                                              .providersList[index];

                                                      Navigator.pushNamed(
                                                        context,
                                                        AppRoutes
                                                            .bookAppointmentScreen,
                                                        arguments: {
                                                          'providerData':
                                                              provider,
                                                          'subCategoryId':
                                                              provider
                                                                  .subCategoryResponseModel
                                                                  ?.subCategoryId,
                                                        },
                                                      );
                                                    },
                                                    child: AppText(
                                                      'Book an Appointment',
                                                      textStyle: TextStyle(
                                                        fontFamily:
                                                            AppStringsKey
                                                                .poppins,
                                                        fontSize: 8.sp,
                                                        color: AppColors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top: 2.h,
                                              bottom: 10.h,
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.pushNamed(
                                                      context,
                                                      AppRoutes.providerDetails,
                                                      arguments: {
                                                        'providerId':
                                                            mJobbersProvider
                                                                .providersList[index]
                                                                .providerID
                                                                .toString(),
                                                        'subcategoryId':
                                                            mJobbersProvider
                                                                .providersList[index]
                                                                .subCategoryResponseModel!
                                                                .subCategoryId,
                                                      },
                                                    );
                                                  },
                                                  child: AppText(
                                                    'View Profile',
                                                    textSize: 10.sp,
                                                    textColor:
                                                        AppColors.textBlue,
                                                    decorationColor:
                                                        AppColors.textBlue,
                                                    textDecoration:
                                                        TextDecoration
                                                            .underline,
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    IconButton(
                                                      onPressed:
                                                          () => CommonUtils.checkCallPermission(
                                                            mJobbersProvider
                                                                .providersList[index]
                                                                .phoneNumber
                                                                .toString(),
                                                          ),
                                                      icon: ClipRRect(
                                                        child: Image.asset(
                                                          AppImages.callIcon,
                                                          color:
                                                              AppColors.primary,
                                                          height: 20.h,
                                                          width: 20.w,
                                                        ),
                                                      ),
                                                    ),
                                                    // IconButton(
                                                    //   onPressed: () {
                                                    //     debugPrint(
                                                    //       'chat with provider',
                                                    //     );
                                                    //   },
                                                    //   icon: ClipRRect(
                                                    //     child: Image.asset(
                                                    //       AppImages.chatIcon,
                                                    //       color:
                                                    //           AppColors.primary,
                                                    //       height: 20.h,
                                                    //       width: 20.w,
                                                    //     ),
                                                    //   ),
                                                    // ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15.h),
                              ],
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

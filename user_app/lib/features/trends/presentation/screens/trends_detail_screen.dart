import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resize/resize.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user/constants/app_colors.dart';
import 'package:user/di/di.dart';
import 'package:user/features/trends/data/models/getall_trends_model.dart';
import 'package:user/widgets/app_bar.dart';
import 'package:user/widgets/app_text.dart';
import 'package:user/widgets/loading_widget.dart';
import 'package:user/widgets/profilecircular.dart';

class TrendsDetailScreen extends ConsumerStatefulWidget {
  final TrendsModel trend;

  const TrendsDetailScreen({super.key, required this.trend});

  @override
  ConsumerState<TrendsDetailScreen> createState() => _TrendsDetailScreenState();
}

class _TrendsDetailScreenState extends ConsumerState<TrendsDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(trendsProvider).getMoreTrends(widget.trend.mediaId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    log(widget.trend.firstName.toString());

    return Resize(
      builder:
          () => Scaffold(
            backgroundColor: AppColors.white,
            body: SafeArea(
              child: Column(
                children: [
                  // Fixed AppBar (not scrollable)
                  CustomAppBar(
                    leadingIconHeight: 22.5.h,
                    textSize: 16.sp,
                    showLeadingIcon: true,
                    leadingIconEnabled: true,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),

                  // Scrollable Content
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Trend Image (no padding)
                          // Profile Row
                          Padding(
                            padding: EdgeInsets.only(
                              left: 10.w,
                              right: 10.w,
                              bottom: 10.h,
                            ),
                            child: Row(
                              children: [
                                ProfileCircleAvatar(
                                  radius: 20.w,
                                  imageUrl: widget.trend.profileImage!,
                                ),
                                SizedBox(width: 5.w),
                                Expanded(
                                  child: Text(
                                    "${widget.trend.firstName} ${widget.trend.lastName}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //  SizedBox(height: 10.h),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12.r),
                            child: Image.network(
                              widget.trend.mediaFile,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              loadingBuilder: (
                                context,
                                child,
                                loadingProgress,
                              ) {
                                if (loadingProgress == null) return child;
                                return Shimmer.fromColors(
                                  baseColor: Colors.grey.shade300,
                                  highlightColor: Colors.grey.shade100,
                                  child: Container(
                                    height: 220.h,
                                    width: double.infinity,
                                    color: Colors.white,
                                  ),
                                );
                              },
                              errorBuilder:
                                  (context, error, stackTrace) =>
                                      _buildNoImageWidget(),
                            ),
                          ),

                          // Padding for rest of the content
                          Padding(
                            padding: EdgeInsets.all(10.0.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Description
                                AppText(
                                  widget.trend.description,
                                  textStyle: TextStyle(
                                    fontSize: 13.sp,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 20.h),

                                Consumer(
                                  builder: (context, ref, _) {
                                    final provider = ref.watch(trendsProvider);
                                    final moreTrends = provider.moretrends;

                                    if (provider.isLoading &&
                                        moreTrends.isEmpty) {
                                      return Center(child: LoadingWidget());
                                    }

                                    if (provider.error != null) {
                                      return Text(
                                        "Failed to load more trends",
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 12.sp,
                                        ),
                                      );
                                    }

                                    if (moreTrends.isEmpty) {
                                      return SizedBox.shrink();
                                    }

                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Only shows if moreTrends is not empty
                                        Text(
                                          "More Trends",
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 10.h),

                                        GridView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: moreTrends.length,
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                mainAxisSpacing: 10.h,
                                                crossAxisSpacing: 10.w,
                                                childAspectRatio: 1.5,
                                              ),
                                          itemBuilder: (context, index) {
                                            final item = moreTrends[index];
                                            return ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                              child: Image.network(
                                                item.mediaFile,
                                                fit: BoxFit.cover,
                                                errorBuilder:
                                                    (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) => _buildNoImageWidget(),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                ),

                                SizedBox(height: 20.h),
                              ],
                            ),
                          ),
                        ],
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

Widget _buildNoImageWidget() {
  return Container(
    height: 220.h,
    width: double.infinity,
    color: Colors.grey.shade200,
    alignment: Alignment.center,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.broken_image, color: Colors.grey, size: 30),
        SizedBox(height: 4),
        Text(
          "Unavailable",
          style: TextStyle(color: Colors.grey, fontSize: 11.sp),
        ),
      ],
    ),
  );
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/constants/app_colors.dart';
import 'package:provider/constants/app_images.dart';
import 'package:provider/constants/app_strings.dart';
import 'package:provider/di/di.dart';
import 'package:provider/features/Trends/presentation/widgets/trendpostdialog_widget.dart';
import 'package:provider/widgets/app_bar.dart';
import 'package:provider/widgets/app_button.dart';
import 'package:provider/widgets/app_text.dart';
import 'package:provider/widgets/loading_widget.dart';
import 'package:provider/widgets/profilecircleavatar.dart';
import 'package:resize/resize.dart';
import 'package:shimmer/shimmer.dart';

class TrendsScreen extends ConsumerStatefulWidget {
  const TrendsScreen({super.key});

  @override
  TrendsScreenState createState() => TrendsScreenState();
}

class TrendsScreenState extends ConsumerState<TrendsScreen> {
  DateTime? currentBackPressTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(trendsProvider).fetchAllTrends();
    });
  }

  @override
  Widget build(BuildContext context) {
    final mtrendsprovider = ref.watch(trendsProvider);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        debugPrint('pop scope explorescreen called ---- $didPop');
        bool shouldPop = _showBackDialog();
        if (shouldPop == true) {
          exit(0);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Column(
            children: [
              CustomAppBar(
                leadingIcon: AppImages.appLogo,
                showLeadingIcon: true,
                leadingIconHeight: 22.5.h,
              ),

              Expanded(
                child: Builder(
                  builder: (context) {
                    if (mtrendsprovider.isLoading &&
                        mtrendsprovider.allTrends.isEmpty) {
                      return const Center(child: LoadingWidget());
                    }

                    if (mtrendsprovider.errorMessage != null) {
                      return Center(
                        child: Text(
                          // mTrendsProvider.error!,
                          'Something went wrong.',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.red,
                          ),
                        ),
                      );
                    }

                    if (mtrendsprovider.allTrends.isEmpty) {
                      return Center(
                        child: Text(
                          "No trends available right now!",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: mtrendsprovider.allTrends.length,
                      itemBuilder: (context, index) {
                        final post = mtrendsprovider.allTrends[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  ProfileCircleAvatar(
                                    radius: 25.w,
                                    imageUrl:
                                        "https://i.pravatar.cc/150?img=$index",
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        post.providerName ?? '',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: AppStringsKey.poppins,
                                        ),
                                      ),
                                      Text(
                                        post.formattedCreatedAt,
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          fontFamily: AppStringsKey.poppins,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  PopupMenuButton<String>(
                                    onSelected: (value) async {
                                      if (value == 'edit') {
                                        final result = await showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder:
                                              (context) =>
                                                  TrendpostdialogWidget(
                                                    trend: post,
                                                  ),
                                        );

                                        if (result == true) {
                                          ref
                                              .read(trendsProvider)
                                              .fetchAllTrends();
                                        }
                                      } else if (value == 'delete') {
                                        // Show Confirmation Dialog
                                        final bool?
                                        confirmDelete = await showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (context) {
                                            return Dialog(
                                              backgroundColor: AppColors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      5.0.r,
                                                    ),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                  left: 16.w,
                                                  right: 16.w,
                                                  top: 16.h,
                                                  bottom: 16.h,
                                                ),
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      AppText(
                                                        "Delete Trend",
                                                        textSize: 16.sp,
                                                        textColor:
                                                            AppColors.secondary,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                      SizedBox(height: 20.h),
                                                      AppText(
                                                        "Are you sure you want to delete this trend?",
                                                        textColor:
                                                            AppColors
                                                                .fontGreyColor,
                                                        textSize: 12.sp,
                                                      ),
                                                      SizedBox(height: 30.h),
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          Expanded(
                                                            child: AppPrimaryButton(
                                                              backgroundColor:
                                                                  AppColors
                                                                      .tabDividerGrey,
                                                              text: translate(
                                                                AppStringsKey
                                                                    .no,
                                                              ),
                                                              textSize: 14.sp,
                                                              textColor:
                                                                  AppColors
                                                                      .secondary,
                                                              onTap: () {
                                                                Navigator.pop(
                                                                  context,
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                          SizedBox(width: 20.w),
                                                          Expanded(
                                                            child: AppPrimaryButton(
                                                              text: translate(
                                                                AppStringsKey
                                                                    .yes,
                                                              ),
                                                              textSize: 14.sp,
                                                              onTap: () {
                                                                Navigator.pop(
                                                                  context,
                                                                  true,
                                                                ); //
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
                                          },
                                        );

                                        if (confirmDelete == true) {
                                          // Call the delete API
                                          await ref
                                              .read(trendsProvider)
                                              .updateTrends(
                                                "Delete",
                                                post.mediaId,
                                                context,
                                              ); // pass mediaId
                                          ref
                                              .read(trendsProvider)
                                              .fetchAllTrends();
                                        }
                                      }
                                    },
                                    icon: Icon(
                                      Icons.more_horiz,
                                      color: Colors.black,
                                    ),
                                    color:
                                        Colors
                                            .white, // Background color of the menu
                                    elevation: 4, // Drop shadow
                                    shape: RoundedRectangleBorder(
                                      // borderRadius: BorderRadius.circular(10),
                                      side: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    itemBuilder:
                                        (context) => [
                                          PopupMenuItem(
                                            value: 'edit',
                                            child: Row(
                                              children: [
                                                AppText(
                                                  'Edit',
                                                  textStyle: TextStyle(
                                                    fontSize: 12.sp,
                                                    fontFamily:
                                                        AppStringsKey.poppins,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          PopupMenuItem(
                                            value: 'delete',
                                            child: Row(
                                              children: [
                                                AppText(
                                                  'Delete',
                                                  textStyle: TextStyle(
                                                    fontSize: 12.sp,
                                                    fontFamily:
                                                        AppStringsKey.poppins,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                post.description ?? '',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontFamily: AppStringsKey.poppins,
                                ),
                              ),
                              const SizedBox(height: 10),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  post.mediaFile ?? '',
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
                                        height: 200,
                                        color: Colors.white,
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      height: 200,
                                      color: Colors.grey[200],
                                      child: const Center(
                                        child: Icon(
                                          Icons.broken_image,
                                          color: Colors.grey,
                                          size: 40,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
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
        floatingActionButton: FloatingActionButton(
          shape: CircleBorder(),
          backgroundColor: AppColors.primary,
          onPressed: () async {
            final result = await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const TrendpostdialogWidget(),
            );
            // ✅ Refresh trends only if new post was added
            if (result == true) {
              ref.read(trendsProvider).fetchAllTrends();
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Image.asset(
              AppImages.addicon,
              fit: BoxFit.cover,
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }

  bool _showBackDialog() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 1)) {
      currentBackPressTime = now;
      debugPrint('$currentBackPressTime');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.r)),
          ),
          width: 150.w,
          content: AppText(
            'Press again to exit',
            textAlign: TextAlign.center,
            textColor: AppColors.white,
          ),
        ),
      );
      debugPrint('pop scope false');
      return false;
    } else {
      debugPrint('pop scope true');
    }
    return true;
  }
}

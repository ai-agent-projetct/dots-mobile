import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:resize/resize.dart';
import 'package:user/config/app_routes.dart';
import 'package:user/constants/app_colors.dart';
import 'package:user/constants/app_constants.dart';
import 'package:user/constants/app_strings.dart';
import 'package:user/di/di.dart';
import 'package:user/features/home/data/models/dashboard_model.dart';
import 'package:user/utils/helpers/extension.dart';
import 'package:user/widgets/app_bar.dart';
import 'package:user/widgets/app_text.dart';

class CategoryScreen extends ConsumerStatefulWidget {
  const CategoryScreen({super.key, required this.dashboardData, this.catIndex});

  final List<DashboardData> dashboardData;
  final int? catIndex;

  @override
  CategoryScreenState createState() => CategoryScreenState();
}

class CategoryScreenState extends ConsumerState<CategoryScreen> {
  List<bool> expandableItems = [];

  @override
  void initState() {
    super.initState();
    expandableItems = List.generate(
      widget.dashboardData.length,
      (index) => false,
    );
    subItemsHideAndSeek(widget.catIndex);
  }

  @override
  Widget build(BuildContext context) {
    final mexploreProvider = ref.watch(exploreProvider);
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        debugPrint('pop scope called from trade screen ---- $didPop');
      },
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //  SizedBox(height: AppConstants.safeAreaHeight),
              CustomAppBar(
                title: translate(AppStringsKey.category),
                leadingIconHeight: 22.5.h,
                textSize: 16.sp,
                showLeadingIcon: true,
                leadingIconEnabled: true,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              mexploreProvider.errorMessage != null
                  ? Expanded(
                    child: Center(
                      child: Text(
                        'Something went wrong.',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.red,
                        ),
                      ),
                    ),
                  )
                  : widget.dashboardData.isEmpty
                  ? Expanded(
                    child: Center(
                      child: AppText(
                        'Categories are not available',
                        textSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        textColor: AppColors.grey,
                      ),
                    ),
                  )
                  : Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.only(
                        left: 12.w,
                        right: 10.w,
                        bottom: 10.h,
                      ),
                      itemCount: widget.dashboardData.length,
                      itemBuilder: (context, index) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppText(
                                  widget
                                      .dashboardData[index]
                                      .categoryResponseModel!
                                      .categoryName
                                      .toString()
                                      .capitalize(),
                                  textSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                                IconButton(
                                  onPressed: () => subItemsHideAndSeek(index),
                                  icon: Icon(
                                    expandableItems[index]
                                        ? Icons.keyboard_arrow_up
                                        : Icons.keyboard_arrow_down,
                                  ),
                                ),
                              ],
                            ),
                            expandableItems[index]
                                ? widget
                                                .dashboardData[index]
                                                .subCategoryModel !=
                                            null &&
                                        widget
                                            .dashboardData[index]
                                            .subCategoryModel!
                                            .isNotEmpty
                                    ? ListView.builder(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.only(left: 30.w),
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount:
                                          widget
                                              .dashboardData[index]
                                              .subCategoryModel!
                                              .length,
                                      itemBuilder: (context, subIndex) {
                                        return InkWell(
                                          onTap: () {
                                            Navigator.pushNamed(
                                              context,
                                              AppRoutes.providersScreen,
                                              arguments: {
                                                'subCatId':
                                                    widget
                                                        .dashboardData[index]
                                                        .subCategoryModel![subIndex]
                                                        .subCategoryId
                                                        .toString(),
                                              },
                                            );
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 2.h,
                                            ),
                                            child: SizedBox(
                                              height: 30.h,
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: AppText(
                                                      '- ${widget.dashboardData[index].subCategoryModel![subIndex].subCategoryName.toString().capitalize()}',
                                                      textSize: 13.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                    : Padding(
                                      padding: EdgeInsets.only(left: 30.w),
                                      child: SizedBox(
                                        height: 30.h,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: AppText(
                                                'SubCategories are not available',
                                                textSize: 12.sp,
                                                fontWeight: FontWeight.w500,
                                                textColor: AppColors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                : Container(),
                            SizedBox(height: 8.h),
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

  void subItemsHideAndSeek(int? index) {
    if (index != null) {
      setState(() {
        expandableItems[index] = !expandableItems[index];
      });
    }
  }
}

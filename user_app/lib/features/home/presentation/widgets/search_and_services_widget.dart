import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:resize/resize.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user/constants/app_colors.dart';
import 'package:user/constants/app_strings.dart';
import 'package:user/di/di.dart';
import 'package:user/features/home/data/models/subactegorytlist_response_model.dart';
import 'package:user/features/menu/presentation/screens/profile_menu_screen.dart';
import 'package:user/utils/helpers/common_utils.dart';
import 'package:user/utils/services/prefs.dart';
import 'package:user/widgets/app_text.dart';
import 'package:user/widgets/app_text_field.dart';
import 'package:user/widgets/profilecircular.dart';
import 'package:user/widgets/show_snackbar.dart';

class SearchAndServicesWidget extends ConsumerStatefulWidget {
  const SearchAndServicesWidget({super.key});

  @override
  SearchAndServicesWidgetState createState() => SearchAndServicesWidgetState();
}

class SearchAndServicesWidgetState
    extends ConsumerState<SearchAndServicesWidget> {
  Future<void> _showProfileDialog(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Dialog(
          backgroundColor: const Color(0xFFFFEBEE),
          insetPadding: EdgeInsets.symmetric(horizontal: 15.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: const ProfileMenuScreen(),
        );
      },
    );
  }

  void onSubCategorySelected(
    String subCatId,
    WidgetRef ref,
    BuildContext context,
  ) {
    final maps = ref.read(mapsProvider);
    final latLng = maps.currentLatLng;

    if (latLng != LatLng(0, 0)) {
      ref
          .read(exploreProvider)
          .getServiceProvidersList(
            latLng.latitude.toString(),
            latLng.longitude.toString(),
            subCatId,
          );
    } else {
      //showSnackBar(message: 'Location not available');
    }
  }

  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log("SearchAndServicesWidget");
    final mExploreProvider = ref.watch(exploreProvider);
    final profile = ref.watch(profileProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: ResizeUtil().screenWidth,
          child: Padding(
            padding: EdgeInsets.only(left: 10.w, right: 10.w),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20.0.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.5),
                    blurRadius: 5.r,
                    spreadRadius: 1.r,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              child: PrimaryTextField(
                mExploreProvider.searchController,
                hint: translate(AppStringsKey.searchForServices),
                fillColor: AppColors.white,
                textInputAction: TextInputAction.search,
                inputFormatter: [
                  FilteringTextInputFormatter.deny(RegExp(r'^[\s]+')),
                ],
                onChanged: (value) {
                  mExploreProvider.setUserSearching(true);
                  mExploreProvider.performSearch(value.trim());
                },
                onFieldSubmitted: (value) {
                  CommonUtils.hideKeyBoard(context);
                  mExploreProvider.setUserSearching(false);
                  mExploreProvider.performSearch(value.trim());
                },

                inputBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0.r),
                  borderSide: const BorderSide(color: AppColors.white),
                ),
                prefixIcon: Padding(
                  padding: EdgeInsets.only(left: 10.w),
                  child: Icon(Icons.search),
                ),
                prefixIconConstraints: BoxConstraints(
                  maxHeight: 20.h,
                  maxWidth: 30.w,
                ),
                suffixIcon: Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: GestureDetector(
                    onTap: () async {
                      CommonUtils.hideKeyBoard(context);
                      // Wait until the dialog is closed
                      await _showProfileDialog(context);

                      // Now reload image AFTER the build frame
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        ref.read(profileProvider).loadPrefs();
                      });
                    },
                    child: ProfileCircleAvatar(
                      radius: 15.r,
                      imageUrl: profile.userImage,
                    ),
                  ),
                ),
                suffixIconConstraints: BoxConstraints(maxWidth: 40.w),
              ),
            ),
          ),
        ),
        if (!mExploreProvider.isUserSearching)
          SizedBox(
            height: 45.h,
            width: ResizeUtil().screenWidth,
            child: Consumer(
              builder: (context, ref, _) {
                final mExploreProvider = ref.watch(exploreProvider);

                if (mExploreProvider.isLoading &&
                    mExploreProvider.subCategoriesList.isEmpty) {
                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 6.h,
                    ),
                    itemCount: 2,
                    separatorBuilder: (_, __) => SizedBox(width: 8.w),
                    itemBuilder: (context, index) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          height: 30.h,
                          width: 100.w,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                        ),
                      );
                    },
                  );
                }

                if (mExploreProvider.subCategoriesList.isEmpty) {
                  return const Center(
                    child: AppText("No sub categories found"),
                  );
                }

                return ListView.builder(
                  controller: _scrollController, // <-- Attach controller
                  scrollDirection: Axis.horizontal,
                  itemCount:
                      mExploreProvider.subCategoriesList.length > 7
                          ? 8
                          : mExploreProvider.subCategoriesList.length,
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 6.h,
                  ),
                  itemBuilder: (context, index) {
                    if (index == 7 &&
                        mExploreProvider.subCategoriesList.length > 7) {
                      return InkWell(
                        onTap: () {
                          CommonUtils.hideKeyBoard(context);
                          _showAllSubCategories(
                            context,
                            mExploreProvider.subCategoriesList,
                          );
                        },
                        child: _buildMoreButton(),
                      );
                    }

                    final item = mExploreProvider.subCategoriesList[index];

                    return InkWell(
                      onTap: () async {
                        final tappedId = item.subCategoryId;

                        setState(() {
                          mExploreProvider.selectedSubCategoryId = tappedId;
                        });
                        log("Tapped: ${item.subCategoryName}");
                        log("Tapped Id: $tappedId");
                        mExploreProvider.searchController.clear();

                        onSubCategorySelected(tappedId, ref, context);
                      },

                      child: IntrinsicWidth(
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: 150.w,
                            minWidth: 100.w,
                          ),
                          margin: EdgeInsets.only(right: 5.0.w),
                          padding: EdgeInsets.symmetric(
                            horizontal: 5.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color:
                                mExploreProvider.selectedSubCategoryId ==
                                        item.subCategoryId
                                    ? Colors
                                        .grey
                                        .shade200 // selected
                                    : AppColors.white,
                            borderRadius: BorderRadius.circular(20.0.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.5),
                                blurRadius: 5.r,
                                spreadRadius: 1.r,
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ClipOval(
                                child: Image.network(
                                  item.subCategoryImage,
                                  fit: BoxFit.cover,
                                  height: 20.h,
                                  width: 20.h,
                                  errorBuilder:
                                      (_, __, ___) => const Icon(
                                        Icons.broken_image,
                                        size: 20,
                                      ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: AppText(
                                  item.subCategoryName.isNotEmpty
                                      ? item.subCategoryName
                                      : "Unnamed",
                                  textSize: 11.sp,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
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
        if (mExploreProvider.searchController.text.isNotEmpty &&
            mExploreProvider.isUserSearching)
          Material(
            color: Colors.transparent,
            child: Container(
              margin: EdgeInsets.all(10),
              constraints: BoxConstraints(maxHeight: 250.h),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child:
                  mExploreProvider.searchResults.isEmpty
                      ? Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 15.h),
                          child: AppText(
                            "No matching subcategories found",
                            textSize: 12.sp,
                          ),
                        ),
                      )
                      : ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: mExploreProvider.searchResults.length,
                        itemBuilder: (context, index) {
                          final result = mExploreProvider.searchResults[index];
                          return ListTile(
                            title: AppText(result['name'], textSize: 12.sp),

                            onTap: () {
                              CommonUtils.hideKeyBoard(context);
                              final tappedId = result['id'];
                              final tappedName = result['name'];

                              // Update search field visually
                              mExploreProvider
                                  .searchController
                                  .value = TextEditingValue(
                                text: tappedName,
                                selection: TextSelection.collapsed(
                                  offset: tappedName.length,
                                ),
                              );

                              // Set selected subcategory
                              mExploreProvider.selectedSubCategoryId = tappedId;

                              // ✅ Stop searching and hide results
                              mExploreProvider.setUserSearching(false);
                              mExploreProvider.clearSearchResultsButKeepText();

                              // Call API
                              onSubCategorySelected(tappedId, ref, context);
                            },
                          );
                        },
                      ),
            ),
          ),
      ],
    );
  }

  Widget _buildMoreButton() {
    return Container(
      width: 120.w,
      margin: EdgeInsets.only(right: 10.0.w),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20.0.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.5),
            blurRadius: 5.r,
            spreadRadius: 1.r,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.more_horiz, size: 22.sp),
          SizedBox(width: 5.w),
          Flexible(
            child: AppText(
              'More',
              textSize: 12.sp,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  void _showAllSubCategories(
    BuildContext context,
    List<SubCategoryListData> list,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10.r)),
      ),
      builder: (context) {
        final mExploreProvider = ref.watch(exploreProvider);

        return FractionallySizedBox(
          heightFactor: 0.5, // Show only 50% height

          child: Padding(
            padding: EdgeInsets.all(10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 6.h),
                AppText(
                  "All Services",
                  textSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(height: 8.h),

                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          ResizeUtil().screenWidth > 600
                              ? 4
                              : 2, // Show 3 per row on phone
                      crossAxisSpacing: 8.w,
                      mainAxisSpacing: 8.h,
                      childAspectRatio: 3, // Smaller item height
                    ),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final item = list[index];
                      return InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          final indexToScroll = list.indexOf(item);

                          setState(() {
                            mExploreProvider.selectedSubCategoryId =
                                item.subCategoryId;
                          });
                          onSubCategorySelected(
                            item.subCategoryId,
                            ref,
                            context,
                          );

                          // Scroll to the selected index after frame is drawn
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (indexToScroll != -1 && indexToScroll < 7) {
                              _scrollController.animateTo(
                                indexToScroll *
                                    110.w, // approximate width per item
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          });
                          log("bottom Tapped: ${item.subCategoryName}");
                          log("bottomTappedid: ${item.subCategoryId}");
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                mExploreProvider.selectedSubCategoryId ==
                                        item.subCategoryId
                                    ? Colors
                                        .grey
                                        .shade200 // selected
                                    : AppColors.white,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: AppColors.greyBorder),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.white,
                                blurRadius: 3.r,
                                spreadRadius: 1.r,
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 4.h,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipOval(
                                child: Image.network(
                                  item.subCategoryImage,
                                  height: 20.h,
                                  width: 20.h,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (_, __, ___) => const Icon(
                                        Icons.broken_image,
                                        size: 20,
                                      ),
                                ),
                              ),
                              SizedBox(
                                width: 5.w,
                              ), // small fixed space between image and text
                              Flexible(
                                fit: FlexFit.loose,
                                child: AppText(
                                  item.subCategoryName.isNotEmpty
                                      ? item.subCategoryName
                                      : "Unnamed",
                                  textSize: 10.sp,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

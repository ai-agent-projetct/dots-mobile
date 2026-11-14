import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';
import 'package:resize/resize.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user/constants/app_colors.dart';
import 'package:user/constants/app_constants.dart';
import 'package:user/constants/app_images.dart';
import 'package:user/constants/app_strings.dart';
import 'package:user/di/di.dart';
import 'package:user/features/home/data/models/dashboard_model.dart';
import 'package:user/utils/helpers/common_utils.dart';
import 'package:user/widgets/app_bar.dart';
import 'package:user/widgets/app_text.dart';
import 'package:user/widgets/app_text_field.dart';
import 'package:user/widgets/loading_widget.dart';
import 'package:user/features/home/presentation/widgets/create_tradepost_dialog.dart';
import 'package:user/widgets/app_images.dart';

class TradeScreen extends ConsumerStatefulWidget {
  const TradeScreen({super.key});

  @override
  TradeScreenState createState() => TradeScreenState();
}

class TradeScreenState extends ConsumerState<TradeScreen> {
  bool showAllChips = false;
  List<dynamic> _searchResults = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // ref.read(exploreProvider).getDashboard();
        ref.read(tradeProvider).fetchTradesByUserId();
        ref.read(tradeProvider).searchController.text = '';
      }
    });
  }

  void _onSearchChanged(String query) {
    final mtradeProvider = ref.read(tradeProvider);
    mtradeProvider.filterTrades(query);

    final trades = mtradeProvider.userTradeData;
    final results = <dynamic>[];
    final seenNames = <String>{};

    if (query.isNotEmpty) {
      for (var trade in trades) {
        final name = trade.userName!.toLowerCase();
        if (name.contains(query.toLowerCase()) && !seenNames.contains(name)) {
          results.add(trade);
          seenNames.add(name);
        }
      }
    }

    setState(() {
      _searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mTradeProvider = ref.watch(tradeProvider);
    final dashboardData = ref.watch(exploreProvider).dasboardData;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        debugPrint('pop scope called from trade screen ---- $didPop');
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomAppBar(
                    title: translate(AppStringsKey.trade),
                    leadingIconHeight: 22.5.h,
                    textSize: 16.sp,
                    showLeadingIcon: true,
                    leadingIconEnabled: true,
                    onTap: () {
                      ref.read(homeProvider).onItemTap(0);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: PrimaryTextField(
                            mTradeProvider.searchController,
                            hint: "Search Trades by Name",
                            onChanged: _onSearchChanged,
                            fillColor: const Color(0xFFEAEAEA),
                            contentPadding: EdgeInsets.only(left: 40.w),
                            inputBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0.r),
                              borderSide: const BorderSide(
                                color: Color(0xFFEAEAEA),
                              ),
                            ),
                            prefixIcon: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              child: const Icon(Icons.search),
                            ),
                            prefixIconConstraints: BoxConstraints(
                              maxHeight: 20.h,
                              maxWidth: 50.w,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10.w),
                          child: PopupMenuButton<String>(
                            onSelected: (value) {
                              // Clear search field
                              CommonUtils.hideKeyBoard(context);
                              mTradeProvider.searchController.clear();
                              setState(() {
                                if (value == "asc") {
                                  mTradeProvider.userTradeData.sort(
                                    (a, b) => "${a.userName}".compareTo(
                                      "${b.userName}",
                                    ),
                                  );
                                } else if (value == "desc") {
                                  mTradeProvider.userTradeData.sort(
                                    (a, b) => "${b.userName}".compareTo(
                                      "${a.userName}",
                                    ),
                                  );
                                }
                              });
                            },
                            color: Colors.white,
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              // borderRadius: BorderRadius.circular(10),
                              side: BorderSide(color: Colors.grey.shade300),
                            ),
                            itemBuilder:
                                (context) => [
                                  const PopupMenuItem(
                                    value: "asc",
                                    child: Text("Sort Ascending"),
                                  ),
                                  const PopupMenuItem(
                                    value: "desc",
                                    child: Text("Sort Descending"),
                                  ),
                                ],
                            child: Image.asset(
                              AppImages.filter,
                              width: 25.w,
                              height: 25.h,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // SizedBox(height: 10.h),
                  // SizedBox(
                  //   height: 30.h,
                  //   width: ResizeUtil().screenWidth,
                  //   child: ListView.builder(
                  //     scrollDirection: Axis.horizontal,
                  //     itemCount:
                  //         showAllChips
                  //             ? dashboardData.length
                  //             : (dashboardData.length > 7
                  //                 ? 8
                  //                 : dashboardData.length),
                  //     padding: EdgeInsets.only(left: 10.w),
                  //     itemBuilder: (context, index) {
                  //       if (!showAllChips &&
                  //           index == 7 &&
                  //           dashboardData.length > 7) {
                  //         return _moreChip();
                  //       }

                  //       final item = dashboardData[index].categoryResponseModel;
                  //       return _chip(item?.catIcon, item?.categoryName);
                  //     },
                  //   ),
                  // ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 5.w,
                      ),
                      child: Builder(
                        builder: (_) {
                          if (mTradeProvider.isLoading &&
                              mTradeProvider.userTradeData.isEmpty) {
                            return const Center(child: LoadingWidget());
                          } else if (mTradeProvider.errorMessage != null) {
                            return Center(
                              child: Text(
                                'Something went wrong.',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.red,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            );
                          } else if (mTradeProvider.filteredTradeData.isEmpty) {
                            return Center(
                              child: Text(
                                "No trade posts available",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          } else {
                            return ListView.builder(
                              itemCount:
                                  mTradeProvider.filteredTradeData.length,
                              padding: EdgeInsets.only(bottom: 10.h, top: 10.h),
                              itemBuilder: (context, index) {
                                final trade =
                                    mTradeProvider.filteredTradeData[index];
                                return _tradeCard(trade);
                              },
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),

              // Suggestion box
              if (_searchResults.isNotEmpty)
                Positioned(
                  top: 90.h,
                  left: 10.w,
                  right: 10.w,
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      constraints: BoxConstraints(maxHeight: 200.h),
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
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final user = _searchResults[index];
                          return ListTile(
                            title: AppText(user.userName),
                            onTap: () {
                              final selectedName = user.userName;
                              mTradeProvider.searchController.text =
                                  selectedName;

                              // filter only for the selected name
                              final trades =
                                  ref
                                      .read(tradeProvider)
                                      .userTradeData
                                      .where(
                                        (trade) => trade.userName!
                                            .toLowerCase()
                                            .contains(
                                              selectedName.toLowerCase(),
                                            ),
                                      )
                                      .toList();

                              setState(() {
                                mTradeProvider.filteredTradeData = trades;
                                _searchResults.clear();
                              });

                              FocusScope.of(context).unfocus();
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: 'tradeFab',
          onPressed: () async {
            final result = await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const TradePostDialog(),
            );

            if (result == true) {
              await ref.read(tradeProvider).fetchTradesByUserId();
            }
          },
          backgroundColor: AppColors.primary,
          elevation: 3,
          shape: const CircleBorder(),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Image.asset(
              AppImages.addButtonImage,
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _moreChip() {
    return InkWell(
      onTap: () {
        setState(() {
          showAllChips = true;
        });
      },
      child: Container(
        width: 120.w,
        height: 40.h,
        margin: EdgeInsets.only(right: 10.0.w),
        decoration: BoxDecoration(
          color: const Color(0xFFEAEAEA),
          borderRadius: BorderRadius.circular(20.0.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 0.8,
              spreadRadius: 0.8,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.more_horiz, size: 20.sp),
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
      ),
    );
  }

  Widget _chip(String? iconUrl, String? label) {
    return Container(
      width: 120.w,
      margin: EdgeInsets.only(right: 10.0.w),
      decoration: BoxDecoration(
        color: const Color(0xFFEAEAEA),
        borderRadius: BorderRadius.circular(20.0.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 0.8,
            spreadRadius: 0.8,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppNetworkImage(
            url: iconUrl ?? '',
            height: 20.h,
            width: 20.w,
            fit: BoxFit.cover,
          ),
          SizedBox(width: 5.w),
          Flexible(
            child: AppText(
              label ?? '',
              textSize: 11.sp,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tradeCard(dynamic trade) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 110.w,
              height: 100.h,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5.r),
                child: Image.network(
                  trade.uploadImage ?? '',
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        width: 110.w,
                        height: 100.h,
                        color: Colors.white,
                      ),
                    );
                  },
                  errorBuilder: (_, __, ___) => _buildNoImageWidget(),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    trade.userName,
                    textSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  AppText(
                    DateFormat('d MMM y').format(
                      trade.createdAt != null
                          ? DateTime.tryParse(trade.createdAt!)?.toLocal() ??
                              DateTime.now()
                          : DateTime.now(),
                    ),
                    textColor: AppColors.fontGreyColor,
                    textSize: 10.sp,
                  ),
                  SizedBox(height: 7.h),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 40.h),
                    child: SingleChildScrollView(
                      child: AppText(
                        trade.description ?? '',
                        textAlign: TextAlign.justify,
                        textSize: 10.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
      ],
    );
  }

  Widget _buildNoImageWidget() {
    return Container(
      height: 100.h,
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
}

import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:resize/resize.dart';
import 'package:user/constants/app_colors.dart';
import 'package:user/constants/app_strings.dart';
import 'package:user/di/di.dart';
import 'package:user/features/home/presentation/screens/bottom_navigation.dart';
import 'package:user/features/offers/data/models/getalloffers_model.dart';
import 'package:user/features/offers/presentation/provider/offers_provider.dart';
import 'package:user/features/offers/presentation/screens/interested_screen.dart';
import 'package:user/utils/helpers/common_utils.dart';
import 'package:user/widgets/app_bar.dart';
import 'package:user/widgets/app_text.dart';
import 'package:user/widgets/app_text_field.dart';
import 'package:user/widgets/loading_widget.dart';
import 'package:user/widgets/show_snackbar.dart';

class OffersScreen extends ConsumerStatefulWidget {
  const OffersScreen({super.key});

  @override
  OffersScreenState createState() => OffersScreenState();
}

class OffersScreenState extends ConsumerState<OffersScreen> {
  bool _showInitBanner = true;

  @override
  void initState() {
    super.initState();

    // Hide initial banner
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showInitBanner = false;
        });
      }
    });

    // Fetch offers only once
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (mounted) {
    //     final provider = ref.read(offersProvider);
    //     provider.getAllOffers();
    //     //     provider.getAllOffers().then((_) {
    //     //   provider.clearSelection(); // Clear selections on page load
    //     // });
    //   }
    // });

    Future.microtask(() async {
      final provider = ref.read(offersProvider);
      await provider.loadSelectedOffersFromPrefs();
      final maps = ref.read(mapsProvider);
      final latLng = maps.currentLatLng;

      if (latLng != LatLng(0, 0)) {
        await provider.getAllOffers(latLng.latitude, latLng.longitude);
      } else {
        //  showSnackBar(message: 'Location not available');
      }
    });
  }

  List<String> _searchResults = [];
  void _onSearchChanged(String query) {
    final offers = ref.read(offersProvider).offers;

    // Use a Set to avoid duplicates
    final results = <String>{};

    if (query.isNotEmpty) {
      offers.forEach((subcategory, offerList) {
        // Match subcategory
        if (subcategory.toLowerCase().contains(query.toLowerCase())) {
          results.add(subcategory);
        }

        // Match offers
        for (var offer in offerList) {
          if (offer.subCategoryName.toLowerCase().contains(
            query.toLowerCase(),
          )) {
            results.add(
              offer.subCategoryName,
            ); // Set will automatically avoid duplicates
          }
        }
      });
    }

    // Convert Set back to List for UI
    setState(() {
      _searchResults = results.toList();
    });
  }

  bool _hasFilteredResults(OffersProvider mOffersProvider, String searchText) {
    if (searchText.isEmpty) return true;

    bool hasResults = false;
    mOffersProvider.offers.forEach((category, subCategoryOffers) {
      if (category.toLowerCase().contains(searchText)) {
        hasResults = true;
      } else if (subCategoryOffers.any(
        (offer) => offer.subCategoryName.toLowerCase().contains(searchText),
      )) {
        hasResults = true;
      }
    });
    return hasResults;
  }

  @override
  Widget build(BuildContext context) {
    final mOffersProvider = ref.watch(offersProvider);
    final sliderImages = mOffersProvider.dynamicSliderImages;
    final searchText =
        mOffersProvider.searchController.text.trim().toLowerCase();
    final hasFilteredResults = _hasFilteredResults(mOffersProvider, searchText);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        debugPrint('pop scope called from offers screen ---- $didPop');
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Stack(
            children: [
              /// Main Column (Wrap it in Positioned.fill or SizedBox.expand for constraints)
              Positioned.fill(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // App Bar
                    CustomAppBar(
                      title: translate(AppStringsKey.alertText),
                      leadingIconHeight: 22.5.h,
                      textSize: 16.sp,
                      showLeadingIcon: true,
                      leadingIconEnabled: true,
                      onTap: () {
                        ref
                            .read(homeProvider)
                            .onItemTap(0); // ← This is correct

                        //  mhomeProvider.onItemTap(index);
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder:
                        //         (context) => const BottomNavigationScreen(
                        //           initialIndex: 0,
                        //         ),
                        //   ),
                        //   //(route) => false,
                        // );
                      },

                      // Determine if filtered results are empty
                      showAction:
                          mOffersProvider.offers.isNotEmpty &&
                          mOffersProvider.error == null &&
                          hasFilteredResults,

                      actionText: "Continue",
                      actionIcon: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: AppColors.primary,
                      ),
                      onActionTap: () async {
                        final provider = ref.read(offersProvider);

                        if (!provider.isSelectionValid()) {
                          showSnackBar(
                            message: "Please select at least 1 offer",
                          );
                          return;
                        }

                        log(
                          "Selected Offer IDs: ${provider.selectedOfferIds}",
                        ); // ✅ Log here

                        final selectedIds = provider.selectedOfferIds;
                        bool success = await provider.selectedOffersPost(
                          selectedIds,
                        );

                        if (success) {
                          await provider.saveSelectedOffersToPrefs();
                          provider.mergeSelectedOffers(selectedIds.toSet());

                          final home = ref.read(homeProvider);
                          home.currentTabScreen = InterestedScreen(
                            groupedOffers: provider.selectedOffersGrouped,
                          );
                          home.onItemTap(1);
                        }
                      },
                    ),

                    // Search bar
                    Padding(
                      padding: EdgeInsets.only(
                        left: 10.w,
                        right: 10.w,
                        bottom: 10.w,
                      ),
                      child: PrimaryTextField(
                        mOffersProvider.searchController,
                        textInputAction: TextInputAction.search,
                        onChanged: _onSearchChanged,
                        hint: "Search Offers...",
                        fillColor: const Color(0xFFEAEAEA),
                        contentPadding: EdgeInsets.only(left: 40.w),
                        inputBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0.r),
                          borderSide: const BorderSide(
                            color: Color(0xFFEAEAEA),
                          ),
                        ),
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(left: 10.w, right: 10.w),
                          child: const Icon(Icons.search),
                        ),
                        prefixIconConstraints: BoxConstraints(
                          maxHeight: 20.h,
                          maxWidth: 50.w,
                        ),
                      ),
                    ),

                    // Scrollable content
                    Expanded(
                      child:
                          mOffersProvider.isLoading &&
                                  mOffersProvider.offers.isEmpty
                              ? Center(child: LoadingWidget())
                              : mOffersProvider.error != null
                              ? Center(
                                child: Text(
                                  'Something went wrong',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              )
                              : mOffersProvider.offers.isEmpty
                              ? Center(
                                child: Text(
                                  'No offers available',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              )
                              : SingleChildScrollView(
                                child: Column(
                                  children: [
                                    // Carousel Slider
                                    if (sliderImages.isNotEmpty)
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10.w,
                                        ),
                                        child: Stack(
                                          children: [
                                            CarouselSlider.builder(
                                              itemCount: sliderImages.length,
                                              itemBuilder: (
                                                context,
                                                index,
                                                realIdx,
                                              ) {
                                                return ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        5.r,
                                                      ),
                                                  child: Image.network(
                                                    sliderImages[index],
                                                    fit: BoxFit.cover,
                                                    width: double.infinity,
                                                    errorBuilder:
                                                        (_, __, ___) =>
                                                            buildNoImageWidget(),
                                                  ),
                                                );
                                              },
                                              carouselController:
                                                  mOffersProvider
                                                      .carouselController,
                                              options: CarouselOptions(
                                                autoPlay: true,
                                                height: 30.vh,
                                                viewportFraction: 1,
                                                onPageChanged: (index, reason) {
                                                  if (mounted) {
                                                    mOffersProvider.updateIndex(
                                                      index,
                                                    );
                                                  }
                                                },
                                              ),
                                            ),

                                            // Indicators
                                            Positioned(
                                              bottom: 10.h,
                                              left: 0,
                                              right: 0,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children:
                                                    sliderImages.asMap().entries.map((
                                                      entry,
                                                    ) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          mOffersProvider
                                                              .carouselController
                                                              .animateToPage(
                                                                entry.key,
                                                              );
                                                        },
                                                        child: Container(
                                                          width: 6.w,
                                                          height: 6.h,
                                                          margin:
                                                              EdgeInsets.symmetric(
                                                                horizontal: 2.w,
                                                                vertical: 2.h,
                                                              ),
                                                          decoration: BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color:
                                                                mOffersProvider
                                                                            .currentIndex ==
                                                                        entry
                                                                            .key
                                                                    ? AppColors
                                                                        .primary
                                                                    : Colors
                                                                        .white,
                                                          ),
                                                        ),
                                                      );
                                                    }).toList(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    // Offers Section
                                    _buildOffersList(mOffersProvider),
                                  ],
                                ),
                              ),
                    ),
                  ],
                ),
              ),
              if (_searchResults.isNotEmpty)
                Positioned(
                  top: 85.h, // Adjust to appear below search bar
                  left: 9.w,
                  right: 9.w,
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
                          return ListTile(
                            title: AppText(_searchResults[index]),
                            onTap: () {
                              mOffersProvider.searchController.text =
                                  _searchResults[index];
                              FocusScope.of(context).unfocus();
                              setState(() => _searchResults.clear());
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
              // Initial Banner
              if (_showInitBanner)
                Positioned(
                  bottom: 10.h,
                  left: 10.w,
                  right: 10.w,
                  child: _buildInitBanner(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Offers list extracted for readability
  Widget _buildOffersList(OffersProvider mOffersProvider) {
    // Get search text
    final searchText =
        mOffersProvider.searchController.text.trim().toLowerCase();

    // Filtered offers map
    final filteredOffers = <String, List<Offer>>{};

    if (searchText.isNotEmpty) {
      // Filter based on category or subCategoryName
      mOffersProvider.offers.forEach((category, subCategoryOffers) {
        // Category matches
        if (category.toLowerCase().contains(searchText)) {
          filteredOffers[category] = subCategoryOffers;
        } else {
          // Filter offers by subcategory name
          final matchedOffers =
              subCategoryOffers
                  .where(
                    (offer) => offer.subCategoryName.toLowerCase().contains(
                      searchText,
                    ),
                  )
                  .toList();
          if (matchedOffers.isNotEmpty) {
            filteredOffers[category] = matchedOffers;
          }
        }
      });
    }

    final offersToShow =
        searchText.isNotEmpty ? filteredOffers : mOffersProvider.offers;

    if (mOffersProvider.offers.isEmpty) {
      return Container(
        height: MediaQuery.of(context).size.height - kToolbarHeight,
        alignment: Alignment.center,
        child: Text(
          'No offers available',
          style: TextStyle(color: Colors.grey, fontSize: 14.sp),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: offersToShow.keys.length,
        itemBuilder: (context, index) {
          String category = offersToShow.keys.elementAt(index);
          List<Offer> subCategoryOffers = offersToShow[category]!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(category, fontWeight: FontWeight.w600, textSize: 14.sp),
              SizedBox(height: 10.h),
              SizedBox(
                height: 150.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: subCategoryOffers.length,
                  itemBuilder: (context, subIndex) {
                    Offer offer = subCategoryOffers[subIndex];
                    bool isSelected = mOffersProvider.selectedSubcategories
                        .contains("$index-$subIndex");

                    return InkWell(
                      onTap:
                          () => mOffersProvider.toggleSubcategory(
                            index,
                            subIndex,
                            offer,
                          ),
                      child: Padding(
                        padding: EdgeInsets.only(right: 8.w),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5.r),
                              child: Image.network(
                                offer.uploadImage,
                                width: 130.w,
                                height: 150.h,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (_, __, ___) => buildNoImageWidget(),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              child: Checkbox(
                                value: isSelected,
                                checkColor: AppColors.primary,
                                activeColor: const Color(0xffffffff),
                                onChanged:
                                    (v) => mOffersProvider.toggleSubcategory(
                                      index,
                                      subIndex,
                                      offer,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20.h),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInitBanner() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.check_box, color: AppColors.primary),
          SizedBox(width: 8.w),
          const Expanded(
            child: Text(
              "Select your Interest Offers & Continue",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildNoImageWidget() {
  return Container(
    height: 200.h,
    width: 130.w,
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

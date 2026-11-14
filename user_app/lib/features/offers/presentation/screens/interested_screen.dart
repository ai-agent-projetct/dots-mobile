import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resize/resize.dart';
import 'package:user/constants/app_colors.dart';
import 'package:user/di/di.dart';
import 'package:user/features/offers/data/models/getalloffers_model.dart';
import 'package:user/features/offers/presentation/screens/offers_screen.dart';
import 'package:user/utils/helpers/common_utils.dart';
import 'package:user/widgets/app_bar.dart';
import 'package:user/widgets/app_text.dart';
import 'package:user/widgets/app_text_field.dart';
import 'package:user/widgets/common_widgets.dart' hide buildNoImageWidget;

class InterestedScreen extends ConsumerStatefulWidget {
  final Map<String, List<Offer>> groupedOffers;

  const InterestedScreen({super.key, required this.groupedOffers});

  @override
  ConsumerState<InterestedScreen> createState() => _InterestedScreenState();
}

class _InterestedScreenState extends ConsumerState<InterestedScreen> {
  int? selectedIndex;
  final TextEditingController _searchController = TextEditingController();
  String searchText = "";
  Offer? selectedSubcategory;
  bool showSuggestions = false;

  @override
  Widget build(BuildContext context) {
    final categoryList = widget.groupedOffers.keys.toList();
    final query = searchText.toLowerCase();
    final mOffersProvider = ref.watch(offersProvider);

    // Suggestions list (only subcategories)
    final List<Map<String, dynamic>> suggestions = [];
    final Set<String> seen = {};

    if (query.isNotEmpty) {
      widget.groupedOffers.forEach((category, offers) {
        // if query matches category, show its subcategories
        if (category.toLowerCase().contains(query)) {
          for (var offer in offers) {
            if (seen.add(offer.subCategoryName.toLowerCase())) {
              suggestions.add({"category": category, "offer": offer});
            }
          }
        } else {
          // Otherwise match subcategory
          for (var offer in offers) {
            if (offer.subCategoryName.toLowerCase().contains(query) &&
                seen.add(offer.subCategoryName.toLowerCase())) {
              suggestions.add({"category": category, "offer": offer});
            }
          }
        }
      });
    }

    List<Offer> displayOffers = [];
    if (searchText.isEmpty && selectedIndex == null) {
      displayOffers = widget.groupedOffers.values.expand((e) => e).toList();
    } else if (selectedSubcategory != null) {
      displayOffers = [selectedSubcategory!];
    } else if (selectedIndex != null) {
      final selectedCategory = categoryList[selectedIndex!];
      displayOffers = widget.groupedOffers[selectedCategory]!;
    }

    return WillPopScope(
      onWillPop: () async => true,
      // false,
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Stack(
            children: [
              mOffersProvider.error != null
                  ? Center(
                    child: Text(
                      'Something went wrong',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 14.sp,
                      ),
                    ),
                  )
                  : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomAppBar(
                        showAction: true,
                        actionText: "+Add",
                        underlineActionText: true,
                        onActionTap: () {
                          ref.read(homeProvider).currentTabScreen =
                              const OffersScreen();
                          ref.read(homeProvider).notifyListeners();
                        },
                      ),

                      // Search bar
                      Padding(
                        padding: EdgeInsets.all(10.w),
                        child: PrimaryTextField(
                          _searchController,
                          hint: "Search for Category or Subcategory",
                          // fillColor: AppColors.backGroundGrey,
                          contentPadding: EdgeInsets.only(left: 40.w),
                          inputBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0.r),
                            borderSide: const BorderSide(
                              color: AppColors.greyBorder,
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
                          onChanged: (val) {
                            setState(() {
                              searchText = val;
                              selectedIndex = null;
                              selectedSubcategory = null;
                              showSuggestions = val.isNotEmpty;
                            });
                          },
                        ),
                      ),

                      // Chips (only when suggestion box is closed)
                      if (!showSuggestions)
                        SizedBox(
                          height: 40.h,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: categoryList.length,
                            itemBuilder: (_, index) {
                              final isSelected = selectedIndex == index;
                              return Padding(
                                padding: EdgeInsets.only(left: 10.w),
                                child: ChoiceChip(
                                  label: AppText(
                                    categoryList[index],
                                    textColor:
                                        isSelected
                                            ? AppColors.primary
                                            : AppColors.black,
                                  ),
                                  selected: isSelected,
                                  selectedColor: AppColors.backGroundGrey,
                                  backgroundColor: AppColors.backGroundGrey,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.r),
                                    side: BorderSide(
                                      color: AppColors.backGroundGrey,
                                    ),
                                  ),
                                  showCheckmark: false,
                                  onSelected: (_) {
                                    CommonUtils.hideKeyBoard(context);
                                    _searchController.clear();

                                    setState(() {
                                      searchText = "";
                                      selectedIndex = index;
                                      selectedSubcategory = null;
                                      showSuggestions = false;
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                        ),

                      // Main list
                      Expanded(
                        child: ListView.separated(
                          padding: EdgeInsets.all(10.w),
                          itemCount: displayOffers.length,
                          separatorBuilder: (_, __) => SizedBox(height: 10.h),
                          itemBuilder: (context, index) {
                            final offer = displayOffers[index];
                            final discountValue =
                                double.tryParse(offer.discount) ?? 0;
                            final badge = "${discountValue.toInt()}% OFF";

                            return _offerCard(
                              title: offer.title,
                              highlight: offer.subCategoryName,
                              description: offer.description,
                              imagePath: offer.uploadImage,
                              badge: badge,
                            );
                          },
                        ),
                      ),
                    ],
                  ),

              // Suggestion box overlay
              if (showSuggestions)
                Positioned(
                  left: 10.w,
                  right: 10.w,
                  top: 100.h, // adjust based on search bar height
                  child: Container(
                    constraints: BoxConstraints(maxHeight: 250.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AppColors.backGroundGrey),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child:
                        suggestions.isNotEmpty
                            ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: suggestions.length,
                              itemBuilder: (context, index) {
                                final item = suggestions[index];
                                final offer = item["offer"] as Offer;
                                final category = item["category"] as String;

                                return ListTile(
                                  title: Text(offer.subCategoryName),
                                  //subtitle: Text(category),
                                  onTap: () {
                                    CommonUtils.hideKeyBoard(context);
                                    setState(() {
                                      selectedSubcategory = offer;
                                      selectedIndex = categoryList.indexOf(
                                        category,
                                      );
                                      _searchController.text =
                                          offer.subCategoryName;
                                      searchText = offer.subCategoryName;
                                      showSuggestions = false;
                                    });
                                  },
                                );
                              },
                            )
                            : Padding(
                              padding: EdgeInsets.all(15),
                              child: Center(
                                child: Text(
                                  "No offers available",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                  ),
                                ),
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

  Widget _offerCard({
    required String title,
    required String highlight,
    required String description,
    required String imagePath,
    String? badge,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: Image.network(
              imagePath,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Center(child: buildNoImageWidget()),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  title,
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),
                if (badge != null)
                  Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      child: AppText(badge, textColor: AppColors.white),
                    ),
                  ),
                SizedBox(height: 5.h),
                AppText(description),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

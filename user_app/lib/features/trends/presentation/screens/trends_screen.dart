import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:resize/resize.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user/constants/app_colors.dart';
import 'package:user/constants/app_images.dart';
import 'package:user/constants/app_strings.dart';
import 'package:user/di/di.dart';
import 'package:user/features/trends/data/models/getall_trends_model.dart';
import 'package:user/features/trends/presentation/screens/trends_detail_screen.dart';
import 'package:user/utils/helpers/common_utils.dart';
import 'package:user/widgets/app_bar.dart';
import 'package:user/widgets/app_text.dart';
import 'package:user/widgets/app_text_field.dart';
import 'package:user/widgets/loading_widget.dart';
import 'package:user/widgets/profilecircular.dart';
import 'package:user/widgets/show_snackbar.dart';

class TrendsScreen extends ConsumerStatefulWidget {
  const TrendsScreen({super.key});

  @override
  TrendsScreenState createState() => TrendsScreenState();
}

class TrendsScreenState extends ConsumerState<TrendsScreen> {
  List<String> _searchResults = [];
  bool _isSearching = false;
  String _selectedSearch = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final maps = ref.read(mapsProvider);
        final latLng = maps.currentLatLng;

        if (latLng != LatLng(0, 0)) {
          ref
              .read(trendsProvider)
              .getAllTrends(latLng.latitude, latLng.longitude);
        } else {
          //  showSnackBar(message: 'Location not available');
        }
        ref.read(trendsProvider).searchController.text = '';
      }
    });
  }

  void _onSearchChanged(String query) {
    final mTrendsProvider = ref.read(trendsProvider);

    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _selectedSearch = '';
        _searchResults.clear();
      });
      return;
    }

    final results = <String>{};
    for (var trend in mTrendsProvider.trends) {
      final name = "${trend.firstName} ${trend.lastName}";
      if (name.toLowerCase().contains(query.toLowerCase())) {
        results.add(name);
      }
    }

    setState(() {
      _isSearching = true;
      _searchResults = results.toList();
      _selectedSearch = query; // Update search string
    });
  }

  @override
  Widget build(BuildContext context) {
    var mTrendsProvider = ref.watch(trendsProvider);

    /// Filter list based on search
    final trendsToDisplay =
        (_isSearching && _selectedSearch.isNotEmpty)
            ? mTrendsProvider.trends
                .where(
                  (trend) => "${trend.firstName} ${trend.lastName}"
                      .toLowerCase()
                      .contains(_selectedSearch.toLowerCase()),
                )
                .toList()
            : mTrendsProvider.trends;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppBar(
                  title: translate(AppStringsKey.trendsText),
                  leadingIconHeight: 22.5.h,
                  textSize: 16.sp,
                  showLeadingIcon: true,
                  leadingIconEnabled: true,
                  onTap: () {
                    ref.read(homeProvider).onItemTap(0);
                  },
                ),

                /// Search bar
                Padding(
                  padding: EdgeInsets.only(
                    left: 10.w,
                    right: 10.w,
                    bottom: 10.h,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: PrimaryTextField(
                          mTrendsProvider.searchController,
                          hint: "Search Trends by Name",
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
                            padding: EdgeInsets.only(left: 10.w, right: 10.w),
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
                            mTrendsProvider.searchController.clear();
                            setState(() {
                              if (value == "asc") {
                                mTrendsProvider.trends.sort(
                                  (a, b) =>
                                      "${a.firstName} ${a.lastName}".compareTo(
                                        "${b.firstName} ${b.lastName}",
                                      ),
                                );
                              } else if (value == "desc") {
                                mTrendsProvider.trends.sort(
                                  (a, b) =>
                                      "${b.firstName} ${b.lastName}".compareTo(
                                        "${a.firstName} ${a.lastName}",
                                      ),
                                );
                              }
                            });
                          },
                          color: Colors.white, // Background color of the menu
                          elevation: 4, // Drop shadow
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

                /// Trends list
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Builder(
                      builder: (context) {
                        if (mTrendsProvider.isLoading &&
                            mTrendsProvider.trends.isEmpty) {
                          return const Center(child: LoadingWidget());
                        } else if (mTrendsProvider.error != null) {
                          return buildMessage(
                            "Something went wrong.",
                            color: AppColors.red,
                          );
                        } else if (trendsToDisplay.isEmpty) {
                          // If search doesn't match or trends empty
                          return buildMessage("No trends available.");
                        } else {
                          return MasonryGridView.builder(
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 5,
                            gridDelegate:
                                SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                ),
                            itemCount: trendsToDisplay.length,
                            itemBuilder: (context, index) {
                              final trend = trendsToDisplay[index];
                              return _buildTrendCard(trend);
                            },
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),

            /// Suggestion box
            if (_searchResults.isNotEmpty)
              Positioned(
                top: 85.h,
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
                            mTrendsProvider.searchController.text =
                                _searchResults[index];
                            setState(() {
                              _selectedSearch = _searchResults[index];
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
    );
  }

  Widget _buildTrendCard(TrendsModel trend) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(5.r)),
          child:
              trend.mediaFile.isNotEmpty
                  ? Image.network(
                    trend.mediaFile,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) => _buildNoImageWidget(),
                  )
                  : _buildNoImageWidget(),
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            InkWell(
              onTap: () {
                CommonUtils.hideKeyBoard(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TrendsDetailScreen(trend: trend),
                  ),
                );
              },
              child: ProfileCircleAvatar(
                radius: 20.w,
                imageUrl: trend.profileImage!,
              ),
            ),
            SizedBox(width: 5.w),
            Expanded(
              child: AppText(
                "${trend.firstName} ${trend.lastName}",
                textSize: 12.sp,
              ),
            ),
          ],
        ),
      ],
    );
  }
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

Widget buildMessage(String message, {Color color = Colors.grey}) {
  return Center(
    child: Text(
      message,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: color,
      ),
    ),
  );
}

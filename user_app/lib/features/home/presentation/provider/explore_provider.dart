import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sliding_up_panel/flutter_sliding_up_panel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:resize/resize.dart';
import 'package:user/constants/app_images.dart';
import 'package:user/di/di.dart';
import 'package:user/features/home/data/models/dashboard_model.dart';
import 'package:user/features/home/data/models/subactegorytlist_response_model.dart';
import 'package:user/features/home/domain/usecase/dashboard_usecase.dart';
import 'package:user/features/home/domain/usecase/getsubcategorylist_usecase.dart';
import 'package:user/features/serviceProvider/data/models/provider_details_model.dart';
import 'package:user/features/serviceProvider/data/models/providers_list_model.dart';
import 'package:user/features/serviceProvider/domain/usecase/providers_list_usecase.dart';
import 'package:user/widgets/show_snackbar.dart';

class ExploreProvider extends ChangeNotifier {
  final DashboardUsecase dashboardUsecase;
  final GetsubcategorylistUsecase getsubcategorylistUsecase;
  final ProvidersListUsecase providersListUsecase;
  final Ref ref;
  bool isLoading = false;
  List<DashboardData> dasboardData = [];

  String? errorMessage;
  setLoader(bool isLoading) {
    this.isLoading = isLoading;
    notifyListeners();
  }

  List<SubCategoryListData> subCategoriesList = [];
  String? selectedSubCategoryId;

  Future<void> getSubCtaegoryList() async {
    errorMessage = null;
    setLoader(true);

    final result = await getsubcategorylistUsecase.getSubCtaegoryList();

    if (result.isLeft()) {
      final failure = result.getLeft();
      errorMessage = failure.toString();
      showSnackBar(message: errorMessage!);
      log("Offers Error: $errorMessage");
    } else {
      subCategoriesList = result.getRight().data;
      notifyListeners();
    }

    setLoader(false);
  }

  ScrollController scrollController = ScrollController();

  SlidingUpPanelController panelController = SlidingUpPanelController();

  bool collapsed = false;

  bool subCategoryVisible = false;

  double minChildSize = 0.05;
  double maxChildSize = 1.0;
  double initialChildSize = 0.30;

  double floatingBottomPosition = 0.05;

  ExploreProvider(
    this.dashboardUsecase,
    this.getsubcategorylistUsecase,
    this.providersListUsecase,
    this.ref,
  ) {
    scrollController.addListener(() {
      if (scrollController.offset >=
              scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        panelController.expand();
        debugPrint('scrolling up 1');
      } else if (scrollController.offset <=
              scrollController.position.minScrollExtent &&
          !scrollController.position.outOfRange) {
        panelController.anchor();
        debugPrint('scrolling up');
      }
    });
  }
  Future<void> getDashboard() async {
    setLoader(true);
    errorMessage = null; // reset old error

    var data = await dashboardUsecase.getDashboard();

    if (data.isLeft()) {
      // store the error message
      errorMessage = data.getLeft().error;
      setLoader(false);
    } else {
      dasboardData = data.getRight().dashboardData!;
      setLoader(false);
    }
  }

  void changeBottomPosition(SlidingUpPanelStatus status) {
    if (status == SlidingUpPanelStatus.collapsed) {
      floatingBottomPosition =
          (minChildSize + 0.005) * ResizeUtil().screenHeight;
    } else {
      floatingBottomPosition =
          (initialChildSize - 0.05) * ResizeUtil().screenHeight;
    }

    notifyListeners();
  }

  void changeShapeOfSlidingPanel() {
    if (SlidingUpPanelStatus.expanded == panelController.status) {
      collapsed = true;
      panelController.anchor();
    } else if (SlidingUpPanelStatus.anchored == panelController.status) {
      if (collapsed == true) {
        panelController.collapse();
      } else {
        panelController.expand();
      }
    } else if (SlidingUpPanelStatus.collapsed == panelController.status) {
      collapsed = false;
      panelController.anchor();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  final TextEditingController searchController = TextEditingController();

  List<Map<String, dynamic>> searchResults = [];

  void performSearch(String query) {
    log("Searching in subCategoriesList...");
    searchResults = performSearchHelper(query.trim(), subCategoriesList);
    notifyListeners();
  }

  List<Map<String, dynamic>> performSearchHelper(
    String query,
    List<SubCategoryListData> subCategoryList,
  ) {
    if (query.isEmpty) return [];

    query = query.toLowerCase();

    final matches =
        subCategoryList
            .where((sub) => sub.subCategoryName.toLowerCase().contains(query))
            .map(
              (sub) => {"id": sub.subCategoryId, "name": sub.subCategoryName},
            )
            .toList();

    return matches;
  }

  void clearSearch() {
    searchResults = [];
    searchController.clear();
    notifyListeners();
  }

  void clearSearchResultsButKeepText() {
    searchResults = [];
    notifyListeners();
  }

  List<ProvidersData> providersList = [];

  Future<void> getServiceProvidersList(
    String lat,
    String lng,
    String subCatId,
  ) async {
    try {
      providersList.clear();
      notifyListeners();

      var result = await providersListUsecase.getProvidersList(
        lat,
        lng,
        subCatId,
      );

      if (result.isLeft()) {
        final error = result.getLeft().error;
        if (error == "Providers not available for the Unknown service.") {
          showSnackBar(
            message: "No service providers avilable in your location",
          );
        } else {
          showSnackBar(message: error);
        }
        log('Error fetching providers: $error');
      } else {
        final data = result.getRight();
        if (data.providersData != null && data.providersData!.isNotEmpty) {
          providersList = data.providersData!;
          log('Fetched providers: ${providersList.length}');
        } else {
          log('No providers found for this subcategory.');
        }
      }
    } catch (e) {
      log('Exception: $e');
      showSnackBar(message: 'Something went wrong');
    } finally {
      notifyListeners();

      // ✅ Center map to user location every time after markers are loaded
      final mapsProv = ref.read(mapsProvider);
      final controller = await mapsProv.controller.future;
      if (mapsProv.currentLatLng != const LatLng(0, 0)) {
        controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: mapsProv.currentLatLng, zoom: 15),
          ),
        );
      }
    }
  }

  bool isUserSearching = false;

  void setUserSearching(bool value) {
    isUserSearching = value;
    notifyListeners();
  }

  void clearProviders() {
    providersList.clear();
    selectedSubCategoryId = null;
    searchController.text = '';
    notifyListeners();
  }
}

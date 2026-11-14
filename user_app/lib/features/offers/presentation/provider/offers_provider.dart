import 'dart:convert';
import 'dart:developer';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user/constants/app_colors.dart';
import 'package:user/constants/app_images.dart';
import 'package:user/features/offers/data/models/getalloffers_model.dart';
import 'package:user/features/offers/domain/usecases/getalloffers_usecase.dart';
import 'package:user/features/offers/domain/usecases/selectedofferspost_usecase.dart';
import 'package:user/widgets/show_snackbar.dart';

class OffersProvider extends ChangeNotifier {
  final GetAllOffersUsecae _getAllOffersUsecase;
  final SelectedOffersPostUsecase _selectedOffersPostUsecase;

  OffersProvider(this._getAllOffersUsecase, this._selectedOffersPostUsecase);

  bool _isLoading = false;
  String? _error;
  Map<String, List<Offer>> _offers = {};

  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, List<Offer>> get offers => _offers;

  Set<String> selectedSubcategories = {};
  Set<String> selectedOfferIds = {};

  void toggleSubcategory(int mainIndex, int subIndex, Offer offer) {
    final key = "$mainIndex-$subIndex";

    if (selectedSubcategories.contains(key)) {
      selectedSubcategories.remove(key);
      selectedOfferIds.remove(offer.offerId);
    } else {
      selectedSubcategories.add(key);
      selectedOfferIds.add(offer.offerId);
    }

    notifyListeners();
  }

  Future<void> getAllOffers(double lat, double lon) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _getAllOffersUsecase.getAllOffers(lat, lon);

    if (result.isLeft()) {
      final failure = result.getLeft();
      _error = failure.toString();
      log("Offers Error: $_error");
    } else {
      final success = result.getRight();
      _offers = success.data;
      log("Offers Success: ${_offers.length} categories loaded");
      restoreSelectedSubcategoriesFromOfferIds();
    }

    _isLoading = false;
    notifyListeners();
  }

  void restoreSelectedSubcategoriesFromOfferIds() {
    selectedSubcategories.clear();

    int mainIndex = 0;
    _offers.forEach((category, offerList) {
      for (int subIndex = 0; subIndex < offerList.length; subIndex++) {
        final offer = offerList[subIndex];
        if (selectedOfferIds.contains(offer.offerId)) {
          final key = "$mainIndex-$subIndex";
          selectedSubcategories.add(key);
        }
      }
      mainIndex++;
    });

    log("Restored selectedSubcategories: $selectedSubcategories");
  }

  List<Offer> _selectedOfferDetails = [];
  List<Offer> get selectedOfferDetails => _selectedOfferDetails;
  Map<String, List<Offer>> _selectedOffersGrouped = {};

  Future<bool> selectedOffersPost(Set<String> offerIds) async {
    try {
      final body = {"offer_ids": offerIds.toList()};
      final result = await _selectedOffersPostUsecase.selectedOffersPost(body);

      if (result.isLeft()) {
        showSnackBar(message: result.getLeft().error);
        return false;
      } else {
        final responseData = result.getRight().data;
        log("responseData: $responseData");

        _selectedOffersGrouped.clear();

        responseData.forEach((categoryName, offersList) {
          _selectedOffersGrouped[categoryName] =
              (offersList as List).map((e) {
                if (e is Offer) {
                  return e;
                } else if (e is Map<String, dynamic>) {
                  return Offer.fromJson(e);
                } else {
                  throw Exception("Unknown type: ${e.runtimeType}");
                }
              }).toList();
        });

        _selectedOfferDetails =
            _selectedOffersGrouped.values.expand((list) => list).toList();

        notifyListeners();
        showSnackBar(
          message: result.getRight().message,
          bgColor: AppColors.oliveGreen,
        );
        return true;
      }
    } catch (e, stack) {
      debugPrint('Error in selectedOffersPost: $e');
      debugPrintStack(stackTrace: stack);
      showSnackBar(message: "Something went wrong. Please try again.");
      return false;
    }
  }

  final searchController = TextEditingController();
  final CarouselSliderController carouselController =
      CarouselSliderController();
  var currentIndex = 0;

  List<String> get dynamicSliderImages {
    List<String> images = [];
    _offers.forEach((category, offerList) {
      for (var offer in offerList) {
        if (offer.uploadImage.isNotEmpty) {
          images.add(offer.uploadImage);
        }
      }
    });
    return images;
  }

  void clearSelection() {
    selectedSubcategories.clear();
    selectedOfferIds.clear();
    _selectedOfferDetails.clear();
    notifyListeners();
  }

  final List<int> selectedIndices = [];

  bool isSelectionValid() {
    return selectedSubcategories.length >= 1;
  }

  void updateIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }

  Future<void> loadSavedOffers() async {
    final prefs = await SharedPreferences.getInstance();
    final savedOffersJson = prefs.getString('selectedOffers');
    if (savedOffersJson != null) {
      final List<dynamic> jsonList = json.decode(savedOffersJson);
      selectedOfferIds = Set<String>.from(jsonList);
      notifyListeners();
    }
  }

  Future<void> saveSelectedOffers() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'selectedOffers',
      json.encode(selectedOfferIds.toList()),
    );
  }

  void mergeSelectedOffers(Set<String> newOffers) {
    selectedOfferIds.addAll(newOffers);
    saveSelectedOffers();
    notifyListeners();
  }

  Future<void> saveSelectedOffersToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('selected_offer_ids', selectedOfferIds.toList());
  }

  Future<void> loadSelectedOffersFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    selectedOfferIds =
        (prefs.getStringList('selected_offer_ids') ?? []).toSet();
  }

  Future<void> syncOffersWithStoredSelection() async {
    final prefs = await SharedPreferences.getInstance();
    final storedIds = prefs.getStringList('selected_offer_ids') ?? [];

    selectedOfferIds =
        storedIds
            .where(
              (id) => _offers.values
                  .expand((list) => list)
                  .any((offer) => offer.offerId == id),
            )
            .toSet();
  }

  Map<String, List<Offer>> get selectedOffersGrouped {
    return _offers.map((key, value) {
      final filtered =
          value
              .where((offer) => selectedOfferIds.contains(offer.offerId))
              .toList();
      return MapEntry(key, filtered);
    })..removeWhere((key, value) => value.isEmpty);
  }
}

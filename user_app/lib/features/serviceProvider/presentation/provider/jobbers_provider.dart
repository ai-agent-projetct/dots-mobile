import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:user/constants/app_colors.dart';
import 'package:user/constants/app_images.dart';
import 'package:user/features/serviceProvider/data/models/provider_details_model.dart';
import 'package:user/features/serviceProvider/data/models/providers_list_model.dart';
import 'package:user/features/serviceProvider/data/models/rating_response_model.dart';
import 'package:user/features/serviceProvider/domain/usecase/createreview_usecase.dart';
import 'package:user/features/serviceProvider/domain/usecase/getratings_usecase.dart';
import 'package:user/features/serviceProvider/domain/usecase/provider_details_usecase.dart';
import 'package:user/features/serviceProvider/domain/usecase/providers_list_usecase.dart';
import 'package:user/utils/helpers/common_utils.dart';
import 'package:user/widgets/show_snackbar.dart';

class JobbersProvider extends ChangeNotifier {
  final ProvidersListUsecase providersListUsecase;
  final ProviderDetailsUsecase providerDetailsUsecase;
  final CreateReviewUsecase createReviewUsecase;
  final GetRatingsUsecase getRatingsUsecase;
  bool showAllImages = false;
  final PageController reviewPageController = PageController();

  JobbersProvider(
    this.providersListUsecase,
    this.providerDetailsUsecase,
    this.createReviewUsecase,
    this.getRatingsUsecase,
  );

  List<ProvidersData> providersList = [];

  ProviderDetailsData? providerDetailsData;

  bool isLoading = false;

  setLoader(bool isLoading) {
    this.isLoading = isLoading;
    notifyListeners();
  }

  var currentIndex = 0;
  void updateIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }

  Future<void> getServiceProvidersList(
    String lat,
    String lng,
    String subCatId,
  ) async {
    setLoader(true);

    var data = await providersListUsecase.getProvidersList(lat, lng, subCatId);
    if (data.isLeft()) {
      setLoader(false);
      // showSnackBar(message: data.getLeft().error);

      final error = data.getLeft().error;
      if (error == "Providers not available for the Unknown service.") {
        showSnackBar(message: "No service providers avilable in your location");
      } else {
        showSnackBar(message: error);
      }
      log(data.getLeft().error);
    } else {
      providersList = data.getRight().providersData!;
      log(providersList.toString());

      setLoader(false);
      notifyListeners();
    }
  }

  Future<void> getServiceProviderDetails(String id) async {
    setLoader(true);
    var data = await providerDetailsUsecase.getProviderDetails(id);
    if (data.isLeft()) {
      setLoader(false);
      showSnackBar(message: data.getLeft().error);
    } else {
      await getRatings(id);
      providerDetailsData = data.getRight().providerDetailsData!;

      setLoader(false);
      notifyListeners();
    }
  }

  double rating = 0;
  final TextEditingController reviewtextController = TextEditingController();

  Future<void> handleSubmit(BuildContext context) async {
    if (rating == 0) {
      CommonUtils.showToast("Please give a rating");
      return;
    }
    if (reviewtextController.text.trim().isEmpty) {
      CommonUtils.showToast("Please write a review");
      return;
    }

    final success = await createReview();

    // Close bottom sheet
    Navigator.of(context).pop();

    // if (success && providerDetailsData?.proID != null) {
    //   // Refresh provider details after success
    //   await getRatings(providerDetailsData!.providerID!);
    // }
  }

  bool iscreateLoading = false;
  Future<bool> createReview() async {
    final body = {
      "provider_id": providerDetailsData?.providerID ?? '',
      "rating": rating,
      "reviews": reviewtextController.text.trim(),
    };
    iscreateLoading = true;
    notifyListeners();
    var data = await createReviewUsecase.createReview(body);
    iscreateLoading = false;
    notifyListeners();

    if (data.isLeft()) {
      showSnackBar(message: data.getLeft().error);
      return false;
    } else {
      await getRatings(providerDetailsData?.providerID);
      showSnackBar(
        message: "Review submitted successfully",
        bgColor: AppColors.oliveGreen,
      );
      reviewtextController.clear();
      rating = 0;
      return true;
    }
  }

  RatingData? ratingData;
  Future<void> getRatings(String providerId) async {
    // setLoader(true);
    var data = await getRatingsUsecase.getRatings(providerId);
    // setLoader(false);

    if (data.isLeft()) {
      showSnackBar(message: data.getLeft().error);
    } else {
      // store rating data safely
      ratingData = data.getRight().data;
    }
  }

  @override
  void dispose() {
    reviewPageController.dispose();
    reviewtextController.dispose();
    super.dispose();
  }
}

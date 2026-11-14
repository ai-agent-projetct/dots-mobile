import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/constants/app_colors.dart';
import 'package:provider/features/alert/data/model/getalloffers_model.dart';
import 'package:provider/features/alert/data/model/selectedservice_response_model.dart';
import 'package:provider/features/alert/domain/usecases/createoffer_usercase.dart';
import 'package:provider/features/alert/domain/usecases/getalloffers_usecase.dart';
import 'package:provider/features/alert/domain/usecases/getproviderservices_usecase.dart';
import 'package:provider/features/alert/domain/usecases/updateoffer_usecase.dart';
import 'package:provider/utils/helpers/common_utils.dart';
import 'package:provider/widgets/show_snackbar.dart';

class AlertProvider extends ChangeNotifier {
  final GetAllOffersUsecase getAllOffersUsecase;
  final UpdateofferUsecase updateofferUsecase;
  final GetProviderServicesUsecase getProviderServicesUsecase;
  final CreateOfferUsercase createofferUsecase;
  AlertProvider(
    this.getAllOffersUsecase,
    this.updateofferUsecase,
    this.getProviderServicesUsecase,
    this.createofferUsecase,
  );
  final descriptionController = TextEditingController();
  final headingController = TextEditingController();
  final discountController = TextEditingController();

  DateTime? validFrom;
  DateTime? validTo;

  bool isActive = false;

  List<OfferItem> allOffers = [];
  bool isLoading = false;
  String? errorMessage;

  List<CategoryModel> categories = [];
  List<SubCategoryModel> subCategories = [];
  List<String> categoryNames = [];
  List<String> subCategoryNames = [];

  String? selectedCategory;
  String? selectedSubCategory;

  String? subCategoryId;
  String? categoryId;
  Future<void> getProviderServices() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final data = await getProviderServicesUsecase.getProviderServices();

    if (data.isLeft()) {
      errorMessage = data.getLeft().error;
    } else {
      final response = data.getRight();

      categories =
          response.data.categories
              .map(
                (cat) => CategoryModel(
                  categoryId: cat.categoryId,
                  catId: cat.catId,
                  categoryName: cat.categoryName,
                  categoryImage: cat.categoryImage,
                ),
              )
              .toList();

      categoryNames = categories.map((e) => e.categoryName).toList();

      subCategories =
          response.data.subcategories
              .map(
                (sub) => SubCategoryModel(
                  categoryId: sub.categoryId,
                  subCategoryId: sub.subCategoryId,
                  subId: sub.subId,
                  subCategoryName: sub.subCategoryName,
                  subCategoryImage: sub.subCategoryImage,
                ),
              )
              .toList();

      subCategoryNames = subCategories.map((e) => e.subCategoryName).toList();
    }
    isLoading = false;
    notifyListeners();
  }

  Future<bool> createOffer(Map<String, dynamic> body) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final data = await createofferUsecase.createOffer(body);

      if (data.isLeft()) {
        errorMessage = data.getLeft().error;
        showSnackBar(message: errorMessage!);
        return false;
      } else {
        final offerResponse = data.getRight();
        clearControllers();
        showSnackBar(
          message: offerResponse.message,
          bgColor: AppColors.oliveGreen,
        );
        return true;
      }
    } catch (e) {
      errorMessage = "Something went wrong: $e";
      showSnackBar(message: errorMessage!);
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getAllOffers() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final data = await getAllOffersUsecase.getAllOffers();

    if (data.isLeft()) {
      errorMessage = data.getLeft().error;
      allOffers = [];
    } else {
      allOffers = data.getRight().data;
    }

    isLoading = false;
    notifyListeners();
  }

  String offerupdated = '';
  Future<bool> updateOffer(
    BuildContext context,
    String offerId,
    Map<String, dynamic> body,
  ) async {
    try {
      log(offerId);
      isLoading = true;
      offerupdated = "";
      notifyListeners();

      final data = await updateofferUsecase.updateOffer(offerId, body);

      if (data.isLeft()) {
        showSnackBar(message: data.getLeft().error);
        return false;
      } else {
        offerupdated = data.getRight().message;
        showSnackBar(message: offerupdated, bgColor: AppColors.oliveGreen);
        return true;
      }
    } catch (e) {
      showSnackBar(message: "Something went wrong: $e");
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
      //Navigator.pop(context);
    }
  }

  bool validateForm(BuildContext context) {
    if (headingController.text.trim().isEmpty) {
      CommonUtils.showToast("Please enter heading");
      return false;
    }

    if (descriptionController.text.trim().isEmpty) {
      CommonUtils.showToast("Please enter description");
      return false;
    }

    if (discountController.text.trim().isEmpty) {
      CommonUtils.showToast("Please enter discount");
      return false;
    }
    if (validFrom == null) {
      CommonUtils.showToast("Please select valid from date");
      return false;
    }
    if (validTo == null) {
      CommonUtils.showToast("Please select valid to date");
      return false;
    }
    if (validTo!.isBefore(validFrom!)) {
      CommonUtils.showToast("Valid to date must be after valid from date");
      return false;
    }

    return true;
  }

  void clearControllers() {
    selectedSubCategory = null;
    headingController.clear();
    discountController.clear();
    descriptionController.clear();
    validFrom = null;
    validTo = null;
    isActive = false;
    notifyListeners();
  }
}

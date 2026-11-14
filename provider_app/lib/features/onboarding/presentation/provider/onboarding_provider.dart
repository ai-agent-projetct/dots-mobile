import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/features/onboarding/data/models/category_response_model.dart';
import 'package:provider/features/onboarding/data/models/subcategory_model.dart';
import 'package:provider/features/onboarding/domain/usecase/fileupload_usecase.dart';
import 'package:provider/features/onboarding/domain/usecase/getcategory_usecase.dart';
import 'package:provider/features/onboarding/domain/usecase/getsubcategory_usecase.dart';
import 'package:provider/widgets/show_snackbar.dart';
import 'package:path/path.dart' as p;

class OnboardingProvider extends ChangeNotifier {
  final GetcategoryUsecase getcategoryUsecase;
  final GetSubCategoryUsecase getSubCategoryUsecase;
  final FileUploadUsecase fileUploadUsecase;
  OnboardingProvider(
    this.getcategoryUsecase,
    this.getSubCategoryUsecase,
    this.fileUploadUsecase,
  );
  List<CategoryModel> categories = [];
  List<SubCategoryModel> subCategories = [];

  List<String> categoryNames = [];
  List<String> subCategoryNames = [];

  List<String> selectedSubCategories = [];
  String? selectedCategory;
  Future<void> getCategory() async {
    var data = await getcategoryUsecase.getcategory();
    if (data.isLeft()) {
      showSnackBar(message: data.getLeft().error);
    } else {
      categories = data.getRight().data;
      categoryNames = categories.map((e) => e.categoryName).toList();
      log("categories.length ---> ${categories.length}");
      log("categoryNames ---> $categoryNames");

      notifyListeners();
    }
  }

  Future<void> getSubCategory(String categoryId) async {
    log("categories Id ---> $categoryId ");

    selectedSubCategories.clear(); // Clear old selected items
    subCategoryNames.clear(); // Clear old list too
    notifyListeners(); // Trigger rebuild before loading new ones

    var result = await getSubCategoryUsecase.getSubCategory(categoryId);

    if (result.isLeft()) {
      showSnackBar(message: result.getLeft().error);
    } else {
      subCategories = result.getRight().data;
      subCategoryNames = subCategories.map((e) => e.subCategoryName).toList();
      log("SubCategory Names: $subCategoryNames");
      notifyListeners();
    }
  }

  String selectedImage = "";
  String selectedImageText = "";
  File? pikedImage;
  final ImagePicker _picker = ImagePicker();
  Future<void> pickFromGallery() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      pikedImage = File(picked.path);
      selectedImageText = p.basename(picked.path);
      debugPrint("selectd file name:- $selectedImageText");

      notifyListeners();
    }
  }

  void clearImage() {
    pikedImage = null;
    selectedImageText = "";
    selectedImage = "";
    notifyListeners();
  }

  bool isLoading = false;
  Future<void> uploadFile(File file) async {
    setLoader(true);
    var data = await fileUploadUsecase.fileUpload(file);
    if (data.isLeft()) {
      showSnackBar(message: data.getLeft().error);
      setLoader(false);
    } else {
      if (data.getRight().data != null) {
        if (data.getRight().data!.imageUrl != null) {
          selectedImage = data.getRight().data!.imageUrl.toString();
          notifyListeners();
        }
      }
      setLoader(false);
    }
  }

  setLoader(bool isLoading) {
    this.isLoading = isLoading;
    notifyListeners();
  }
}

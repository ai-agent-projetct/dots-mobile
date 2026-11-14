import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/constants/app_colors.dart';
import 'package:provider/features/Trends/data/model/createtrends_responsemodel.dart';
import 'package:provider/features/Trends/data/model/gettrends_responsemodel.dart';
import 'package:provider/features/Trends/domain/usecases/createtrends_usecase.dart';
import 'package:provider/features/Trends/domain/usecases/getalltrends_usecase.dart';
import 'package:provider/features/Trends/domain/usecases/updatetrends_usecase.dart';
import 'package:provider/features/onboarding/data/models/fileupload_responsemodel.dart';
import 'package:provider/features/onboarding/domain/usecase/fileupload_usecase.dart';
import 'package:provider/utils/either.dart';
import 'package:provider/utils/helpers/common_utils.dart';
import 'package:path/path.dart' as p;
import 'package:provider/utils/network/error.dart';
import 'package:provider/widgets/show_snackbar.dart';

class TrendsProvider extends ChangeNotifier {
  final CreateTrendsUsecase createTrends;
  final FileUploadUsecase fileUploadUsecase;
  final GetAllTrendsUsecase getAllTrendsUsecase;
  final UpdatetrendsUsecase updatetrendsUsecase;
  TrendsProvider(
    this.createTrends,
    this.fileUploadUsecase,
    this.getAllTrendsUsecase,
    this.updatetrendsUsecase,
  );
  bool isLoading = true;
  final descriptionController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  String? selectedImage;
  String selectedImageText = "";
  File? pikedImage;

  Future<void> pickFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      pikedImage = File(pickedFile.path);
      isImageRemoved = false;
      notifyListeners();
    }
  }

  Future<void> pickFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      pikedImage = File(pickedFile.path);
      isImageRemoved = false; // ✅ Reset when new image selected
      notifyListeners();
    }
  }

  setLoader(bool isLoading) {
    this.isLoading = isLoading;
    notifyListeners();
  }

  void clearControllers() {
    descriptionController.clear();
    isImageRemoved = false;
    notifyListeners();
    clearImage();
  }

  void clearImage() {
    selectedImage = null;
    pikedImage = null;
    isImageRemoved = false;
    notifyListeners();
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  List<TrendItem> allTrends = [];
  String? errorMessage;
  Future<void> fetchAllTrends() async {
    try {
      setLoader(true);
      errorMessage = null;
      notifyListeners();

      final result = await getAllTrendsUsecase.getAllTrends();

      if (result.isLeft()) {
        final failure = result.getLeft();
        errorMessage = failure.error.toString();
      } else {
        final response = result.getRight();
        allTrends = response.data;
      }
    } catch (e) {
      errorMessage = "Something went wrong. Please try again.";
    } finally {
      setLoader(false);

      notifyListeners();
    }
  }

  bool isImageRemoved = false;

  Future<bool> uploadAndPostTrend(BuildContext context) async {
    if (descriptionController.text.isEmpty || pikedImage == null) {
      CommonUtils.showToast("Please add image and description");
      return false;
    }

    setLoader(true);
    try {
      final uploadResult = await fileUploadUsecase.fileUpload(pikedImage!);
      if (uploadResult.isLeft()) {
        showSnackBar(message: uploadResult.getLeft().error);
        return false;
      }

      final uploadedUrl = uploadResult.getRight().data?.imageUrl;
      if (uploadedUrl == null || uploadedUrl.isEmpty) {
        CommonUtils.showToast("Image upload failed");
        return false;
      }

      selectedImage = uploadedUrl;

      Map<String, dynamic> request = {
        "description": descriptionController.text.trim(),
        "media_file": selectedImage,
        "media_type": "image",
      };

      final result = await createTrends.createTrends(request);

      if (result.isLeft()) {
        showSnackBar(message: result.getLeft().error);
        return false;
      } else {
        final response = result.getRight();
        debugPrint("Trends created successfully: ${response.data.mediaId}");
        showSnackBar(
          message: "Trend posted successfully",
          bgColor: AppColors.oliveGreen,
        );

        clearImage();
        clearControllers();
        return true;
      }
    } catch (e, stackTrace) {
      debugPrint("Unexpected error: $e\n$stackTrace");
      CommonUtils.showToast("Unexpected error");
      return false;
    } finally {
      setLoader(false);
    }
  }

  Future<bool> updateTrends(
    String key,
    String mediaId,
    BuildContext context,
  ) async {
    setLoader(true);
    errorMessage = null;
    String? uploadedImageUrl;

    if (pikedImage != null) {
      final uploadResult = await fileUploadUsecase.fileUpload(pikedImage!);
      if (uploadResult.isLeft()) {
        uploadedImageUrl = null;
      } else {
        uploadedImageUrl = uploadResult.getRight().data?.imageUrl;
      }
    } else if (isImageRemoved) {
      uploadedImageUrl = null;
    } else {
      uploadedImageUrl = selectedImage;
    }
    if (isImageRemoved) {
      uploadedImageUrl = null;
    }
    Map<String, dynamic> request = {
      "description": descriptionController.text.trim(),
      "media_file": uploadedImageUrl,
      "media_type": "image",
    };
    Map<String, dynamic> deleterequest = {"is_active": 0};
    final result = await updatetrendsUsecase.updateTrends(
      mediaId,
      key == "Delete" ? deleterequest : request,
    );
    setLoader(false);

    if (result.isLeft()) {
      errorMessage = result.getLeft().error.toString();
      showSnackBar(message: errorMessage.toString());
      return false;
    } else {
      final response = result.getRight();
      showSnackBar(message: response.message, bgColor: AppColors.oliveGreen);
      return true;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:user/constants/app_colors.dart';
import 'package:user/constants/app_images.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:user/features/home/data/models/trade_model.dart';
import 'package:user/features/home/domain/usecase/create_trendpost_usecase.dart';
import 'package:user/features/home/domain/usecase/getalltrade_usecase.dart';
import 'package:user/features/home/domain/usecase/gettradebyuserId_usecae.dart';
import 'package:user/features/menu/domain/usecase/file_upload_usecase.dart';
import 'package:user/utils/helpers/common_utils.dart';
import 'package:user/widgets/show_snackbar.dart';

class TradeProvider extends ChangeNotifier {
  GetAllTradePostUsecae getAllTradePostUsecae;
  GetTradeByUserIdUsecae getTradeByUserIdUsecae;
  FileUploadUsecase fileUploadUsecase;
  CreateTrendPostUsecase createTrendPostUsecase;
  TradeProvider(
    this.getAllTradePostUsecae,
    this.getTradeByUserIdUsecae,
    this.fileUploadUsecase,
    this.createTrendPostUsecase,
  );
  final searchController = TextEditingController();
  final descriptionController = TextEditingController();

  bool isLoading = true;

  String selectedImage = "";
  String selectedImageText = "";
  File? pikedImage;

  String? errorMessage;

  List<TradeData> allTrades = [];
  List<TradeData> userTradeData = [];
  List<dynamic> filteredTradeData = [];

  final ImagePicker _picker = ImagePicker();

  Future<void> fetchAllTrades() async {
    setLoader(true);
    errorMessage = null;
    notifyListeners();
    final result = await getAllTradePostUsecae.getAllTradePost();
    if (result.isLeft()) {
      final failure = result.getLeft();
      errorMessage = failure.error;
      notifyListeners();
      showSnackBar(message: "${failure.error}");
    } else {
      allTrades = result.getRight();
    }

    setLoader(false);
  }

  Future<void> fetchTradesByUserId() async {
    errorMessage = null;
    setLoader(true);
    notifyListeners();

    final result = await getTradeByUserIdUsecae.getTradeByUserId();

    if (result.isLeft()) {
      final failure = result.getLeft();
      errorMessage = failure.error;
      //  CommonUtils.showToast("Error: ${failure.error}");

      // showSnackBar(message: "Error: $errorMessage");
    } else {
      userTradeData = result.getRight();
      filteredTradeData = userTradeData;
    }

    setLoader(false);
  }

  void filterTrades(String query) {
    if (query.isEmpty) {
      filteredTradeData = userTradeData;
    } else {
      filteredTradeData =
          userTradeData
              .where(
                (trade) =>
                    trade.userName!.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
    }
    notifyListeners();
  }

  void clearTrades() {
    allTrades = [];
    userTradeData = [];
    notifyListeners();
  }

  Future<void> pickFromGallery() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      pikedImage = File(picked.path);
      selectedImageText = p.basename(picked.path);
      debugPrint("selectd file name:- $selectedImageText");

      notifyListeners();
    }
  }

  Future<void> pickFromCamera() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      pikedImage = File(picked.path);
      selectedImageText = p.basename(picked.path);

      debugPrint("selectd file name:- $selectedImageText");
      notifyListeners();
    }
  }

  Future<void> postTrade() async {
    setLoader(true);

    final request = TradePostRequest(
      uploadImage: selectedImage,
      description: descriptionController.text,
    );

    final result = await createTrendPostUsecase.createTreandPost(
      request.toJson(),
    );

    if (result.isLeft()) {
      showSnackBar(message: result.getLeft().error);
    } else {
      final response = result.getRight();
      final tradeData = TradeData.fromJson(
        response.data as Map<String, dynamic>,
      );
      debugPrint("Trade created successfully: ${tradeData.tradeId}");
      CommonUtils.showToast("Trade posted successfully");
      clearControllers();
    }
    setLoader(false);
  }

  Future uploadFile(File file) async {
    setLoader(true);
    var data = await fileUploadUsecase.fileUpload(file);
    if (data.isLeft()) {
      showSnackBar(message: data.getLeft().error);
      setLoader(false);
    } else {
      if (data.getRight().data != null) {
        if (data.getRight().data!.imageUrl != null) {
          selectedImage = data.getRight().data!.imageUrl.toString();
          debugPrint("uploaded imageUrl:- $selectedImage");
          notifyListeners();
        }
      }
      setLoader(false);
    }
  }

  Future<bool> uploadAndPostTrade(BuildContext context) async {
    if (descriptionController.text.isEmpty || pikedImage == null) {
      CommonUtils.showToast("Please add image and description");
      return false;
    }

    setLoader(true);
    bool isSuccess = false;

    try {
      // Upload image
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

      // Post trade
      final request = TradePostRequest(
        uploadImage: selectedImage,
        description: descriptionController.text,
      );

      final result = await createTrendPostUsecase.createTreandPost(
        request.toJson(),
      );

      if (result.isLeft()) {
        showSnackBar(message: result.getLeft().error);
      } else {
        final response = result.getRight();
        final tradeData = TradeData.fromJson(
          response.data as Map<String, dynamic>,
        );
        debugPrint("Trade created successfully: ${tradeData.tradeId}");
        showSnackBar(
          message: "Trade posted successfully",
          bgColor: AppColors.oliveGreen,
        );
        clearControllers();
        isSuccess = true;
      }
    } catch (e, stackTrace) {
      debugPrint("Unexpected error: $e\n$stackTrace");
      CommonUtils.showToast("Unexpected error");
    } finally {
      setLoader(false);
    }

    return isSuccess;
  }

  setLoader(bool isLoading) {
    this.isLoading = isLoading;
    notifyListeners();
  }

  void clearControllers() {
    debugPrint('cleared controllers');
    searchController.clear();
    descriptionController.clear();
    notifyListeners();
    clearImage();
  }

  void clearImage() {
    selectedImage = "";
    selectedImageText = "";
    pikedImage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    descriptionController.dispose();
    searchController.dispose();
    super.dispose();
  }
}

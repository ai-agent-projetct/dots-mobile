import 'package:flutter/material.dart';
import 'package:provider/constants/app_colors.dart';
import 'package:provider/features/profile/domain/usecase/serviceupdate_usecase.dart';
import 'package:provider/widgets/show_snackbar.dart';

class CategoryProvider extends ChangeNotifier {
  final ServiceUpdateUsecase serviceUpdateUsecase;
  CategoryProvider(this.serviceUpdateUsecase);

  BuildContext? context;
  bool isLoading = false;

  List<String> subCatIds = [];
  setLoader(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<void> updateService() async {
    setLoader(true);
    final body = {"services": subCatIds};

    final data = await serviceUpdateUsecase.serviceUpdate(body);
    setLoader(false);

    if (data.isLeft()) {
      showSnackBar(message: data.getLeft().error);
    } else {
      showSnackBar(
        message: data.getRight().msg.toString(),
        bgColor: AppColors.oliveGreen,
      );
    }
  }
}

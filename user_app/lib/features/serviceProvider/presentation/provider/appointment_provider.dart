import 'package:flutter/material.dart';
import 'package:user/constants/app_colors.dart';
import 'package:user/features/serviceProvider/data/models/providers_list_model.dart';
import 'package:user/features/serviceProvider/domain/usecase/addappointmenty_usecase.dart';
import 'package:user/features/serviceProvider/domain/usecase_impl/addappointment_usecase_impl.dart';
import 'package:user/features/serviceProvider/presentation/screens/apoointmentsummary_screen.dart';
import 'package:user/main.dart';
import 'package:user/widgets/show_snackbar.dart';

class AppointmentProvider extends ChangeNotifier {
  final AddAppointmentUsecase addAppointmentUsecase;
  AppointmentProvider(this.addAppointmentUsecase);

  // Controllers for text fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  DateTime? date;
  TimeOfDay? time;

  bool isLoading = false;
  BuildContext? currentContext;
  setLoader(bool isLoading) {
    this.isLoading = isLoading;
    notifyListeners();
  }

  // Setters
  void setDate(DateTime? value) {
    date = value;
    notifyListeners();
  }

  void setTime(TimeOfDay? value) {
    time = value;
    notifyListeners();
  }

  // Reset form
  void reset() {
    nameController.clear();
    phoneController.clear();
    descriptionController.clear();
    date = null;
    time = null;
    notifyListeners();
  }

  bool isValid() {
    return nameController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        date != null &&
        time != null;
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<bool> addAppointment(body, ProvidersData providerdata) async {
    setLoader(true);
    currentContext = navigatorKey.currentState?.context;

    final result = await addAppointmentUsecase.addAppointment(body);
    setLoader(false);

    if (result.isLeft()) {
      showSnackBar(message: result.getLeft().error);
      return false; // Failed
    } else {
      Navigator.pushReplacement(
        currentContext!,
        MaterialPageRoute(
          builder:
              (_) => AppointmentSummaryScreen(
                data: result.getRight().data,
                providerData: providerdata,
              ),
        ),
      );

      showSnackBar(
        message: result.getRight().message,
        bgColor: AppColors.oliveGreen,
      );
      notifyListeners();
      return true; // Success
    }
  }
}

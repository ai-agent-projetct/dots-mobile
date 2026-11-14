import 'package:flutter/material.dart';
import 'package:provider/features/profile/data/model/getappointments_response_model.dart';
import 'package:provider/features/profile/domain/usecase/getappointments_usecase.dart';
import 'package:provider/widgets/show_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

class AppointmentProvider extends ChangeNotifier {
  final GetAppointmentUsecase getAppointmentUsecase;
  AppointmentProvider(this.getAppointmentUsecase);

  bool isLoading = true;
  String? errorMessage;
  setLoader(bool isLoading) {
    this.isLoading = isLoading;
    notifyListeners();
  }

  List<AppointmentData> appointments = [];

  Future<void> fetchAppointments() async {
    try {
      setLoader(true);
      errorMessage = null;
      notifyListeners();

      final result = await getAppointmentUsecase.getAppointments();

      if (result.isLeft()) {
        final failure = result.getLeft();
        errorMessage = failure.error.toString();
      } else {
        final response = result.getRight();
        appointments = response.data;
      }
    } catch (e) {
      errorMessage = "Something went wrong. Please try again.";
    } finally {
      setLoader(false);
      notifyListeners();
    }
  }

  Future<void> makePhoneCall(BuildContext context, String phoneNumber) async {
    final uri = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      showSnackBar(message: 'Cannot make call');
    }
  }
}

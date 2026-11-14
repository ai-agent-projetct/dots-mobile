import 'package:flutter_translate/flutter_translate.dart';
import 'package:user/constants/app_constants.dart';
import 'package:user/constants/app_strings.dart';

class TextFieldValidator {
  static String? profileUpdateValidation(String? keyName, String input) {
    if (keyName == ApiConstants.fullName) {
      if (input.isEmpty) {
        return null;
      }
      if (input.isNotEmpty && input.length < 3) {
        return translate(AppStringsKey.nameValidation);
      }
    } else if (keyName == ApiConstants.mobile) {
      if (input.isEmpty) {
        return null;
      }
      bool isValidPhone = RegExp(r'^\d{10}$').hasMatch(input);
      if (input.isNotEmpty && !isValidPhone) {
        return translate(AppStringsKey.mobileValidation);
      }
    } else if (keyName == ApiConstants.email) {
      if (input.isEmpty) {
        return null;
      }
      bool isValidEmail = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      ).hasMatch(input);
      if (!isValidEmail) {
        return "Enter a valid email address";
      }
    }
    return null;
  }
}

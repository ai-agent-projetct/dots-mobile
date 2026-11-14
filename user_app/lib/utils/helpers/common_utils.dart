import 'package:fluttertoast/fluttertoast.dart';
import 'package:resize/resize.dart';
import 'package:universal_io/io.dart';
import 'dart:math' as math;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:geolocator/geolocator.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:user/constants/app_colors.dart';
import 'package:user/constants/app_strings.dart';
import 'package:user/widgets/show_snackbar.dart';

class CommonUtils {
  static bool isUrlValid(String url) {
    Uri? uri = Uri.tryParse(url);
    return uri != null && uri.hasScheme && uri.hasAuthority;
  }

  static Future<PackageInfo> getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo;
  }

  static double distanceBetween(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const int radius = 6371000; // Earth's radius in meters
    double latDistance = _toRadians(lat2 - lat1);
    double lonDistance = _toRadians(lon2 - lon1);
    double a =
        math.sin(latDistance / 2) * math.sin(latDistance / 2) +
        math.cos(_toRadians(lat1)) *
            math.cos(_toRadians(lat2)) *
            math.sin(lonDistance / 2) *
            math.sin(lonDistance / 2);
    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return radius * c;
  }

  static double _toRadians(degrees) {
    return degrees * math.pi / 180;
  }

  static String generateRandomBookingNumber({int length = 8}) {
    const chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
  }

  // static void hideKeyBoard(BuildContext context) {
  //   FocusScope.of(context).requestFocus(FocusNode());
  // }
  static void hideKeyBoard(BuildContext context) {
    if (FocusManager.instance.primaryFocus?.hasFocus ?? false) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  static void showToast(message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.SNACKBAR,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 12.0.sp,
    );
  }

  static Future<bool> checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      showSnackBar(
        message: translate(AppStringsKey.locationServicesAreDisabled),
        bgColor: AppColors.red,
      );
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        showSnackBar(
          message: translate(
            AppStringsKey.locationPermissionDeniedForeverEnableFromSettings,
          ),
          bgColor: AppColors.red,
        );
      } else if (permission == LocationPermission.denied) {
        showSnackBar(
          message: translate(
            AppStringsKey.locationDeniedPleaseAllowLocationPermission,
          ),
          bgColor: AppColors.red,
        );
      }
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      return true;
    }
    return false;
  }

  static Future<void> checkCallPermission(String mobile) async {
    canLaunchUrl(Uri(scheme: 'tel', path: mobile)).then((value) async {
      if (value == true) {
        final Uri launchUri = Uri(scheme: 'tel', path: mobile);
        await launchUrl(launchUri);
      } else {
        showSnackBar(message: translate(AppStringsKey.callPermissionDenied));
      }
    });
  }

  static Future<void> checkSmSPermission(String mobile, String data) async {
    late Uri smsLaunchUri;
    if (Platform.isAndroid) {
      smsLaunchUri = Uri.parse('sms:$mobile?body=$data');
    } else if (Platform.isIOS) {
      smsLaunchUri = Uri.parse('sms:$mobile&body=$data');
    }

    canLaunchUrl(smsLaunchUri).then((value) async {
      if (value == true) {
        await launchUrl(smsLaunchUri);
      } else {
        showSnackBar(message: translate(AppStringsKey.smsPermissionDenied));
      }
    });
  }
}

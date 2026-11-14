import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/main.dart';

class AppConstants {
  //Razorpay test and live keys
  static const String razorTestKey = 'rzp_test_J314DNfxi7COdc';
  static const String razorLiveKey = '';

  //map api key
  static const String mapapiKey = 'AIzaSyCghRn20cwTTaaml11gdJorJdP5T7kAk3Y';

  static Size logicalScreenSize =
      PlatformDispatcher.instance.views.first.physicalSize /
      PlatformDispatcher.instance.views.first.devicePixelRatio;

  static double get screenWidth {
    return logicalScreenSize.width;
  }

  static final double screenHeight = logicalScreenSize.height;
  static final safeAreaHeight =
      MediaQuery.of(navigatorKey.currentState!.context).padding.top -
      MediaQuery.of(navigatorKey.currentState!.context).padding.bottom;

  static double get appBarHeight {
    return logicalScreenSize.height * .08;
  }

  static final screenHeightExceptAppbarAndSafeArea =
      screenHeight - (appBarHeight + safeAreaHeight);
}

class ApiConstants {
  static const String firstName = 'First_name';
  static const String lastName = 'Last_name';
  static const String address = 'Address';
  static const String latitude = 'Latitude';
  static const String longitude = 'Longitude';
  static const String mobile = 'Phone_number';
  static const String email = 'Email_Address';
}

import 'package:flutter/foundation.dart';
import 'package:provider/features/home/presentaion/screens/bottomnavigation_screen.dart';
import 'package:provider/features/onboarding/presentation/screens/approvalpending_screen.dart';
import 'package:provider/features/onboarding/presentation/screens/changepassword_screen.dart';
import 'package:provider/features/onboarding/presentation/screens/login_screen.dart';
import 'package:provider/features/onboarding/presentation/screens/otp_screen.dart';
import 'package:provider/features/onboarding/presentation/screens/sign_up_screen.dart';
import 'package:provider/features/onboarding/presentation/screens/splash_screen.dart';
import 'package:provider/features/profile/presentation/screens/about_screen.dart';
import 'package:provider/features/profile/presentation/screens/appointment_screen.dart';
import 'package:provider/features/profile/presentation/screens/category_screen.dart';
import 'package:provider/features/profile/presentation/screens/editprofile_screen.dart';
import 'package:provider/features/profile/presentation/screens/notification_screen.dart';
import 'package:provider/features/profile/presentation/screens/photos&videos_screen.dart';
import 'package:provider/features/profile/presentation/screens/profile_screen.dart';
import 'package:provider/features/profile/presentation/screens/profileupdate_screen.dart';
import 'package:provider/no_internet_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String splash = '/';
  static const String noInternetScreen = '/noInternetScreen';
  static const String loginScreen = '/loginScreen';
  static const String approvalPending = '/  approvalPending';
  static const String signUpScreen = '/signUpScreen';
  static const String otp = '/otp';
  static const String changePwd = '/changePassword';
  static const String bottomNavigation = '/bottomNavigation';
  static const String appointment = '/appointment';
  static const String profile = '/profile';
  static const String profiledetailScreen = '/profileScreen';
  static const String profileUpdate = '/profileUpdate';
  static const String category = '/category';
  static const String photosandvideos = '/photosandvideos';
  static const String notification = '/notification';
  static const String about = '/about';

  static const String editProfile = '/editProfile';
  static String? previousScreen;
  static String? currentScreen;

  static Route<dynamic> onGenerateRoute(RouteSettings setting) {
    return MaterialPageRoute(
      builder: (context) {
        previousScreen = currentScreen;
        currentScreen = setting.name;

        final args = setting.arguments;
        switch (setting.name) {
          case noInternetScreen:
            return NoInternetScreen();

          case splash:
            return SplashScreen();
          case loginScreen:
            return LoginScreen();
          case approvalPending:
            return ApprovalPendingScreen();
          case signUpScreen:
            return SignUpScreen();
          case otp:
            var arguments = args as Map<String, dynamic>;
            return OTPScreen(
              keyName: arguments['keyName'] as String,
              mobile: arguments['mobile'] as String,
            );
          case changePwd:
            return ChangePwdScreen();
          case bottomNavigation:
            return BottomNavigationScreen();
          case profile:
            return ProfileScreen();
          case editProfile:
            return EditProfileScreen();
          case profileUpdate:
            var arguments = args as Map<String, dynamic>;
            return ProfileUpdateScreen(
              keyName: arguments['keyName'] as String,
              data: arguments['data'] as String,
              title: arguments['title'] as String,
              desc: arguments['desc'] as String,
            );
          case notification:
            return NotificationScreen();
          case about:
            return AboutScreen();

          case category:
            return CategoryScreen();

          case photosandvideos:
            return photosandvideosScreen();

          // case profiledetailScreen:
          //   return ProfileDetailsScreen();

          case appointment:
            return AppointmentScreen();

          default:
            return SplashScreen();
        }
      },
    );
  }
}

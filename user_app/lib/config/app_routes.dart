import 'package:universal_io/io.dart';
import 'package:flutter/material.dart';
import 'package:upgrader/upgrader.dart';
import 'package:user/features/home/data/models/dashboard_model.dart';
import 'package:user/features/home/presentation/screens/bottom_navigation.dart';
import 'package:user/features/home/presentation/screens/category_screen.dart';
import 'package:user/features/home/presentation/screens/explore_screen.dart';
import 'package:user/features/home/presentation/screens/poll_screen.dart';
import 'package:user/features/home/presentation/screens/trade_screen.dart';
import 'package:user/features/menu/presentation/screens/menu_screen.dart';
import 'package:user/features/menu/presentation/screens/myappointments_screen.dart';
import 'package:user/features/menu/presentation/screens/notification_screen.dart';
import 'package:user/features/menu/presentation/screens/profile_details_screen.dart';
import 'package:user/features/menu/presentation/screens/profile_pwd_updatescreen.dart';
import 'package:user/features/menu/presentation/screens/profile_update_screen.dart';
import 'package:user/features/offers/presentation/screens/offers_screen.dart';
import 'package:user/features/onboarding/presentation/screens/change_pwd_screen.dart';
import 'package:user/features/onboarding/presentation/screens/login_screen.dart';
import 'package:user/features/onboarding/presentation/screens/onboarding_video.dart';
import 'package:user/features/onboarding/presentation/screens/otp_screen.dart';
import 'package:user/features/onboarding/presentation/screens/sign_up_screen.dart';
import 'package:user/features/onboarding/presentation/screens/splash_screen.dart';
import 'package:user/features/onboarding/presentation/screens/walkthrough_screen.dart';
import 'package:user/features/route/presentation/screens/route_screen.dart';
import 'package:user/features/serviceProvider/data/models/appointment_response_model.dart';
import 'package:user/features/serviceProvider/data/models/providers_list_model.dart';
import 'package:user/features/serviceProvider/presentation/screens/apoointmentsummary_screen.dart';
import 'package:user/features/serviceProvider/presentation/screens/appointment_screen.dart';
import 'package:user/features/serviceProvider/presentation/screens/provider_details_screen.dart';
import 'package:user/features/serviceProvider/presentation/screens/service_providers_screen.dart';
import 'package:user/features/subscriptions/presentation/screens/subscription_history.dart';
import 'package:user/features/trends/presentation/screens/trends_screen.dart';
import 'package:user/no_internet_screen.dart';
import 'package:user/utils/upgrader_msg.dart';

class AppRoutes {
  static const String splash = '/';
  static const String noInternetScreen = '/noInternetScreen';
  static const String walkThrough = '/walkthrough';
  static const String onboardingVideo = '/onboardingVideo';
  static const String loginScreen = '/loginScreen';
  static const String signUpScreen = '/signUpScreen';
  static const String otp = '/otp';
  static const String changePwd = '/changePassword';
  static const String bottomNavigation = '/bottomNavigation';
  static const String explorerPage = '/explorerPage';
  static const String offersPage = '/offersPage';
  static const String interestPage = '/interestPage';
  static const String trendsPage = '/trendsPage';
  static const String routesPage = '/routesPage';
  static const String menuPage = '/menuPage';
  static const String pollScreen = '/pollScreen';
  static const String tradeScreen = '/tradeScreen';
  static const String categoryScreen = '/categoryScreen';
  static const String profileScreen = '/profileScreen';
  static const String providersScreen = '/providersScreen';
  static const String profileUpdate = '/profileUpdate';
  static const String profilePwdUpdate = 'profilePwdUpdate';
  static const String providerDetails = '/providerDetails';
  static const String subscriptionHistory = '/subscriptionHistory';

  static const String notificationScreen = '/notificationScreen';
  static const String bookAppointmentScreen = '/BookAppointmentScreen';
  static const String appointmentSummaryScreen = '/appointmentSummaryScreen';
  static const String myappointments = '/myappointments';

  static String? previousScreen;
  static String? currentScreen;

  static Route<dynamic> onGenerateRoute(RouteSettings setting) {
    return MaterialPageRoute(
      builder: (context) {
        previousScreen = currentScreen;
        currentScreen = setting.name;

        final args = setting.arguments;
        switch (setting.name) {
          case splash:
            return SplashScreen();
          case noInternetScreen:
            return NoInternetScreen();
          case walkThrough:
            return WalkThroughScreen();
          case onboardingVideo:
            return OnboardingVideoScreen(videoUrl: args as String);
          case loginScreen:
            return UpgradeAlert(
              showIgnore: false,
              showLater: false,
              dialogStyle:
                  Platform.isAndroid
                      ? UpgradeDialogStyle.material
                      : UpgradeDialogStyle.cupertino,
              showReleaseNotes: false,
              upgrader: Upgrader(
                durationUntilAlertAgain: const Duration(seconds: 5),
                messages: MyUpgraderMessage(),
                countryCode: 'IN',
              ),
              child: LoginScreen(),
            );
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
            return UpgradeAlert(
              showIgnore: false,
              showLater: false,
              dialogStyle:
                  Platform.isAndroid
                      ? UpgradeDialogStyle.material
                      : UpgradeDialogStyle.cupertino,
              showReleaseNotes: false,
              upgrader: Upgrader(
                durationUntilAlertAgain: const Duration(seconds: 5),
                messages: MyUpgraderMessage(),
                countryCode: 'IN',
              ),
              child: BottomNavigationScreen(),
            );
          case explorerPage:
            return ExploreScreen();
          case offersPage:
            return OffersScreen();
          case trendsPage:
            return TrendsScreen();
          case routesPage:
            return RouteScreen();
          case menuPage:
            return MenuScreen();
          case pollScreen:
            return PollScreen();
          case tradeScreen:
            // var arguments = args as Map<String, dynamic>;
            return TradeScreen(
              // dashboardData: arguments['dashboardData'] as List<DashboardData>,
            );
          case categoryScreen:
            var arguments = args as Map<String, dynamic>;
            return CategoryScreen(
              dashboardData: arguments['dashboardData'] as List<DashboardData>,
              catIndex: arguments['catIndex'],
            );
          case providersScreen:
            var arguments = args as Map<String, dynamic>;
            return ServiceProvidersScreen(
              subCatId: arguments['subCatId'] as String,
            );
          case providerDetails:
            var arguments = args as Map<String, dynamic>;
            return ProviderDetailsScreen(
              providerId: arguments['providerId'] as String,
              subcategoryId: arguments['subcategoryId'] as String,
            );
          case profileScreen:
            return ProfileDetailsScreen();
          case subscriptionHistory:
            return SubscriptionHistory();
          case notificationScreen:
            return NotificationScreen();
          case profileUpdate:
            var arguments = args as Map<String, dynamic>;
            return ProfileUpdateScreen(
              keyName: arguments['keyName'] as String,
              data: arguments['data'] as String,
              title: arguments['title'] as String,
              desc: arguments['desc'] as String,
            );
          case profilePwdUpdate:
            return ProfilePwdUpdateScreen();
          case myappointments:
            return MyAppointmentScreen();

          // case bookAppointmentScreen:
          //   final provider = args as ProvidersData;
          //   return BookAppointmentScreen(provider: provider);

          case bookAppointmentScreen:
            final arguments = args as Map<String, dynamic>;
            final provider = arguments['providerData'] as ProvidersData;
            final subCategoryId = arguments['subCategoryId'] as String?;
            return BookAppointmentScreen(
              provider: provider,
              subCategoryId: subCategoryId!,
            );
          case appointmentSummaryScreen:
            final appointmetdata = args as AppointmentData;
            final providerdata = args as ProvidersData;

            return AppointmentSummaryScreen(
              data: appointmetdata,
              providerData: providerdata,
            );
          default:
            return SplashScreen();
        }
      },
    );
  }
}

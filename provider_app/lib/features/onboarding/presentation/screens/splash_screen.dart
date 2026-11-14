import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/config/app_routes.dart';
import 'package:provider/constants/app_colors.dart';
import 'package:provider/constants/app_images.dart';
import 'package:provider/utils/services/prefs.dart';
import 'package:resize/resize.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends ConsumerState<SplashScreen> {
  bool isInitialized = false;
  bool isNavigated = false; // Prevent multiple navigations
  final double playbackSpeed = 0.5;

  @override
  void initState() {
    super.initState();

    final adjustedDuration = Duration(seconds: (2));
    Future.delayed(adjustedDuration, () {
      if (mounted && !isNavigated) {
        isNavigated = true;
        if (Prefs().getBool(Prefs.isLogin)) {
          Navigator.pushReplacementNamed(context, AppRoutes.bottomNavigation);
        } else {
          Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //ref.watch(onBoardingProvider);
    return Scaffold(
      backgroundColor: AppColors.splashBgColor,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200.w,
              height: 150.h,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AppImages.appLogo),
                  alignment: Alignment.center,
                  repeat: ImageRepeat.noRepeat,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

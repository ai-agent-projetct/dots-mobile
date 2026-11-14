import 'package:flutter/material.dart';
import 'package:user/config/app_routes.dart';
import 'package:user/features/onboarding/data/models/config_model.dart';
import 'package:user/features/onboarding/domain/usecase/splash_usecase.dart';
import 'package:user/main.dart';
import 'package:user/utils/services/prefs.dart';
import 'package:user/widgets/show_snackbar.dart';

class OnboardingProvider extends ChangeNotifier {
  SplashUsecase onboardingUseCase;

  OnboardingProvider(this.onboardingUseCase);

  var isLoading = false;
  var isLastIndex = false;

  final PageController pageController = PageController();
  ConfigModel? configModel;
  BuildContext? currentContext;
  int pageIndex = 0;
  bool fromNotification = false;

  Future<void> getConfigApi() async {
    setLoader(true);
    var data = await onboardingUseCase.getConfig();
    setLoader(false);
    if (data.isLeft()) {
      showSnackBar(message: data.getLeft().error);
    } else {
      configModel = data.getRight();
      currentContext = navigatorKey.currentState?.context;
      await Prefs().setConfigModel(data.getRight());
      Future.delayed(const Duration(seconds: 2), () {
        if (configModel!.data!.onboardingVideo!.isNotEmpty ||
            configModel!.data!.onboardingVideo != null) {
          Navigator.pushReplacementNamed(
            currentContext!,
            AppRoutes.onboardingVideo,
            arguments: configModel!.data!.onboardingVideo,
          );
        }

        // if (Prefs().getBool(Prefs.isLogin)) {
        // Navigator.pushReplacementNamed(
        //     currentContext!, AppRoutes.bottomNavigation);
        //   // if (fromNotification) {
        //   //   fromNotification = false;
        //   //   Navigator.pushNamed(
        //   //       currentContext!, AppRoutes.myRides);
        //   // }
        // } else {
        //   if (Prefs().getBool(Prefs.isWalkThroughCompleted)) {
        //     Navigator.pushReplacementNamed(
        //         currentContext!, AppRoutes.loginScreen);
        //   } else {
        //     if (configModel!.data!.onboardingVideo!.isNotEmpty ||
        //         configModel!.data!.onboardingVideo != null) {
        //       Navigator.pushReplacementNamed(
        //           currentContext!, AppRoutes.onboardingVideo,
        //           arguments: configModel!.data!.onboardingVideo);
        //     }
        //   }
        // }
      });
    }
  }

  void completeOnboarding() {
    Prefs().setBool(Prefs.isWalkThroughCompleted, true);
    notifyListeners();
    Navigator.pushReplacementNamed(
      navigatorKey.currentState!.context,
      AppRoutes.loginScreen,
    );
  }

  setLoader(bool isLoading) {
    this.isLoading = isLoading;
    notifyListeners();
  }

  void onPageChanged(int page) {
    pageIndex = page;
    isLastIndex = false;
    notifyListeners();
  }

  void autoSlide() {
    Future.delayed(const Duration(seconds: 3), () {
      debugPrint('slider length ---> ${configModel!.data!.slider!.length}');
      if (pageIndex < configModel!.data!.slider!.length - 1) {
        pageController.nextPage(
          duration: const Duration(milliseconds: 200),
          curve: Curves.decelerate,
        );
        pageIndex++;
        notifyListeners();
        autoSlide();
      }
      // else {
      //   completeOnboarding();
      // }
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}

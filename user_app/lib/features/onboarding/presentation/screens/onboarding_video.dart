import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:user/config/app_routes.dart';
import 'package:user/utils/services/prefs.dart';
import 'package:video_player/video_player.dart';

class OnboardingVideoScreen extends ConsumerStatefulWidget {
  final String? videoUrl;
  const OnboardingVideoScreen({super.key, this.videoUrl});

  @override
  OnboardingVideoScreenState createState() => OnboardingVideoScreenState();
}

class OnboardingVideoScreenState extends ConsumerState<OnboardingVideoScreen> {
  late VideoPlayerController animationController;
  bool isInitialized = false;
  bool isNavigated = false; // Prevent multiple navigations
  final double playbackSpeed = 0.5;

  @override
  void initState() {
    super.initState();
    debugPrint(widget.videoUrl!);
    animationController =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl!))
          // VideoPlayerController.asset(AppImages.onboardingVideo)
          ..initialize().then((_) {
            setState(() {
              isInitialized = true;
              animationController.setPlaybackSpeed(playbackSpeed);
              animationController.play();
            });
          });
    final adjustedDuration = Duration(seconds: (4 / playbackSpeed).round());
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
    return Scaffold(
      body: isInitialized
          ? VideoPlayer(animationController)
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    debugPrint('video controller clear');
    super.dispose();
  }
}

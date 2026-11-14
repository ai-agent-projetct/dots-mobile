import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/constants/app_strings.dart';
import 'package:provider/widgets/app_text.dart';
import 'package:resize/resize.dart';
import 'package:lottie/lottie.dart';

class NoInternetScreen extends ConsumerStatefulWidget {
  const NoInternetScreen({super.key});

  @override
  NoInternetScreenState createState() => NoInternetScreenState();
}

class NoInternetScreenState extends ConsumerState<NoInternetScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset('assets/raw/no_internet.json', height: 20.vh),
                SizedBox(height: 20.h),
                AppText(
                  AppStringsKey.noInternet,
                  // translate(AppStringsKey.noInternet),
                  textSize: 20.sp,
                  fontFamily: 'Roboto',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

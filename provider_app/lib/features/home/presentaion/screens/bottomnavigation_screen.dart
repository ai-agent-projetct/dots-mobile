import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/constants/app_colors.dart';
import 'package:provider/constants/app_images.dart';
import 'package:provider/constants/app_strings.dart';
import 'package:provider/di/di.dart';
import 'package:resize/resize.dart';

class BottomNavigationScreen extends ConsumerStatefulWidget {
  const BottomNavigationScreen({super.key});
  @override
  BottomNavigationScreenState createState() => BottomNavigationScreenState();
}

class BottomNavigationScreenState
    extends ConsumerState<BottomNavigationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeProvider).resetNavigation();
    });
  }

  @override
  Widget build(BuildContext context) {
    var mhomeProvider = ref.watch(homeProvider);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xffffffff),
      body: PageView(
        controller: mhomeProvider.pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: mhomeProvider.pageChaged,
        children: mhomeProvider.screens,
      ),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Color(0xfff1f5f9),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.5),
              spreadRadius: 1.r,
              blurRadius: 1.0.r,
            ),
          ],
        ),
        child: BottomNavigationBar(
          onTap: (index) {
            mhomeProvider.onItemTap(index);
          },

          selectedItemColor: AppColors.bottomNavigationIconColor,
          unselectedItemColor: const Color(0xFF707070),
          currentIndex: mhomeProvider.bottomIndex,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 12.sp,
          unselectedFontSize: 12.sp,
          backgroundColor: const Color(0xFFFFFFFF),
          elevation: 0.0,
          items: [
            BottomNavigationBarItem(
              icon: SizedBox(
                height: 25.h,
                child: Image.asset(
                  AppImages.trendsicon,
                  color:
                      mhomeProvider.bottomIndex == 0
                          ? AppColors.bottomNavigationIconColor
                          : const Color(0xFF707070),
                ),
              ),
              label: translate(AppStringsKey.trendsText),
            ),
            BottomNavigationBarItem(
              icon: SizedBox(
                height: 25.h,
                child: Image.asset(
                  AppImages.offersicon,
                  color:
                      mhomeProvider.bottomIndex == 1
                          ? AppColors.bottomNavigationIconColor
                          : const Color(0xFF707070),
                ),
              ),
              label: translate(AppStringsKey.alertText),
            ),
            BottomNavigationBarItem(
              icon: SizedBox(
                height: 25.h,
                child: Image.asset(
                  AppImages.mysubscriptionicon,
                  color:
                      mhomeProvider.bottomIndex == 2
                          ? AppColors.bottomNavigationIconColor
                          : const Color(0xFF707070),
                ),
              ),
              label: translate(AppStringsKey.mySubscription),
            ),
            BottomNavigationBarItem(
              icon: SizedBox(
                height: 25.h,
                child: Image.asset(
                  AppImages.profileicon,
                  color:
                      mhomeProvider.bottomIndex == 3
                          ? AppColors.bottomNavigationIconColor
                          : const Color(0xFF707070),
                ),
              ),
              label: translate(AppStringsKey.profile),
            ),
          ],
        ),
      ),
      extendBody: false,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:resize/resize.dart';
import 'package:user/constants/app_colors.dart';
import 'package:user/constants/app_images.dart';
import 'package:user/constants/app_strings.dart';
import 'package:user/di/di.dart';
import 'package:user/features/home/presentation/provider/home_provider.dart';
import 'package:user/features/home/presentation/screens/explore_screen.dart';
import 'package:user/features/home/presentation/screens/poll_screen.dart';
import 'package:user/features/home/presentation/screens/trade_screen.dart';
import 'package:user/features/trends/presentation/screens/trends_screen.dart';
import 'package:user/utils/helpers/common_utils.dart';

class BottomNavigationScreen extends ConsumerStatefulWidget {
  final int initialIndex;

  const BottomNavigationScreen({super.key, this.initialIndex = 0});

  @override
  BottomNavigationScreenState createState() => BottomNavigationScreenState();
}

class BottomNavigationScreenState
    extends ConsumerState<BottomNavigationScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final home = ref.read(homeProvider);
      home.onItemTap(widget.initialIndex);
      home.updateDeviceToken();
      ref.read(exploreProvider).clearProviders();
      await ref.read(mapsProvider).getCurrentPosition();
    });
  }

  @override
  Widget build(BuildContext context) {
    var mhomeProvider = ref.watch(homeProvider);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xffffffff),
      body: IndexedStack(
        index: mhomeProvider.bottomIndex,
        children: [
          const ExploreScreen(),
          mhomeProvider.currentTabScreen,
          const TrendsScreen(),
          const TradeScreen(),
          const PollScreen(),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          CommonUtils.hideKeyBoard(context);
          mhomeProvider.onItemTap(index); // Handles page switch
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
          _bottomItem(
            AppImages.explore,
            0,
            mhomeProvider,
            label: translate(AppStringsKey.exploreText),
          ),
          _bottomItem(
            AppImages.offers,
            1,
            mhomeProvider,
            label: translate(AppStringsKey.alertText),
          ),
          _bottomItem(
            AppImages.trends,
            2,
            mhomeProvider,
            label: translate(AppStringsKey.trendsText),
          ),
          _bottomItem(
            AppImages.statistics,
            3,
            mhomeProvider,
            label: translate(AppStringsKey.trade),
          ),
          _bottomItem(
            AppImages.talks,
            4,
            mhomeProvider,
            label: translate(AppStringsKey.talks),
          ),
        ],
      ),
      extendBody: false,
    );
  }

  BottomNavigationBarItem _bottomItem(
    String asset,
    int index,
    HomeProvider provider, {
    String? label,
  }) {
    return BottomNavigationBarItem(
      icon: SizedBox(
        height: 25.h,
        child: Image.asset(
          asset,
          color:
              provider.bottomIndex == index
                  ? AppColors.bottomNavigationIconColor
                  : const Color(0xFF707070),
        ),
      ),
      label: label ?? "",
    );
  }
}

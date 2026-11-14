import 'package:flutter/material.dart';
import 'package:provider/features/Trends/presentation/screens/trends_screen.dart';
import 'package:provider/features/alert/presentation/screens/alert_screen.dart';
import 'package:provider/features/profile/presentation/screens/profile_screen.dart';
import 'package:provider/features/subscription/presentaion/screens/subscription_screen.dart';

class HomeProvider extends ChangeNotifier {
  HomeProvider();
  var bottomIndex = 0;

  List<Widget> screens = <Widget>[
    const TrendsScreen(),
    const AlertScreen(),
    const SubscriptionScreen(),
    const ProfileScreen(),
  ];

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  void onItemTap(int index) {
    debugPrint('onTap ----> $index');
    bottomIndex = index;
    pageController.jumpToPage(index);
    notifyListeners();
    debugPrint('$bottomIndex');
  }

  void pageChaged(int index) {
    bottomIndex = index;
    notifyListeners();
  }

  void resetNavigation() {
    bottomIndex = 0;
    pageController.jumpToPage(0);
    notifyListeners();
  }
}

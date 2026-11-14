import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:user/di/di.dart';
import 'package:user/features/home/domain/usecase/update_fcm_usecase.dart';
import 'package:user/features/home/presentation/screens/explore_screen.dart';
import 'package:user/features/home/presentation/screens/poll_screen.dart';
import 'package:user/features/home/presentation/screens/trade_screen.dart';
import 'package:user/features/offers/data/models/getalloffers_model.dart';
import 'package:user/features/offers/domain/usecases/getalloffers_usecase.dart';
import 'package:user/features/offers/presentation/screens/interested_screen.dart';
import 'package:user/features/offers/presentation/screens/offers_screen.dart';
import 'package:user/features/trends/presentation/screens/trends_screen.dart';
import 'package:user/utils/helpers/common_utils.dart';
import 'package:user/utils/services/prefs.dart';
import 'package:user/widgets/show_snackbar.dart';

class HomeProvider extends ChangeNotifier {
  final Ref ref;
  final UpdateFcmUsecase updateFcmUsecase;
  final GetAllOffersUsecae getAllOffersUsecase;

  HomeProvider(this.ref, this.updateFcmUsecase, this.getAllOffersUsecase);

  /// Current bottom navigation tab index
  int bottomIndex = 0;

  /// The screen to display when bottomIndex == 1
  Widget currentTabScreen = const OffersScreen();

  /// Static screen list for all other tabs
  final List<Widget> screens = <Widget>[
    const ExploreScreen(),
    const OffersScreen(), // placeholder, won't be used directly
    const TrendsScreen(),
    const TradeScreen(),
    const PollScreen(),
  ];

  /// Called when a bottom tab is tapped
  Future<void> onItemTap(int index) async {
    ref.read(tradeProvider).searchController.text = '';
    ref.read(trendsProvider).searchController.text = '';
    ref.read(pollProvider).searchController.text = '';
    ref.read(offersProvider).searchController.text = '';
    ref.read(exploreProvider).clearProviders();
    notifyListeners();
    bottomIndex = index;

    if (index == 1) {
      // Alert tab
      final offersProv = ref.read(offersProvider);
      await offersProv.loadSelectedOffersFromPrefs();

      if (offersProv.selectedOfferIds.isNotEmpty) {
        final maps = ref.read(mapsProvider);
        final latLng = maps.currentLatLng;

        if (latLng != LatLng(0, 0)) {
          await offersProv.getAllOffers(latLng.latitude, latLng.longitude);
        } else {
          //  showSnackBar(message: 'Location not available');
        }
        currentTabScreen = InterestedScreen(
          groupedOffers: offersProv.selectedOffersGrouped,
        );
      } else {
        currentTabScreen = const OffersScreen();
      }
    } else {
      // Other tabs
      currentTabScreen = screens[index];
    }

    notifyListeners();
  }

  /// Device token update
  void updateDeviceToken() async {
    try {
      String? fcmToken = Prefs().getString(Prefs.fcmToken);
      fcmToken ??= await FirebaseMessaging.instance.getToken();
      var body = {'id': Prefs().getString(Prefs.userId), 'fcm_token': fcmToken};
      var data = await updateFcmUsecase.deviceUpdate(body);
      if (data.isLeft()) {
        showSnackBar(message: data.getLeft().error);
      } else {
        debugPrint('FCM token updated to backend successfully');
      }
    } catch (e) {
      debugPrint('HomeProvider device update error: $e');
    }
  }

  // Offer fetching logic
  bool _isLoading = false;
  String? _error;
  Map<String, List<Offer>> _offers = {};

  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, List<Offer>> get offers => _offers;

  Future<void> getAllOffers(double lat, double lon) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await getAllOffersUsecase.getAllOffers(lat, lon);

    if (result.isLeft()) {
      final failure = result.getLeft();
      _error = failure.toString();
      log("Offers Error: $_error");
    } else {
      final success = result.getRight();
      _offers = success.data;
      log("Offers Success: ${_offers.length} categories loaded");
    }

    _isLoading = false;
    notifyListeners();
  }
}

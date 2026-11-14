import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:user/config/app_routes.dart';
import 'package:user/main.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class InternetProvider extends ChangeNotifier {
  List<ConnectivityResult> connectionStatus = [ConnectivityResult.none];
  final Connectivity connectivity = Connectivity();
  BuildContext? currentContext;
  late StreamSubscription<List<ConnectivityResult>> connectivitySubscription;

  InternetProvider() {
    initConnectivity();
    connectivitySubscription =
        connectivity.onConnectivityChanged.listen(updateConnectionStatus);
  }

  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    try {
      result = await connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      log('Couldn\'t check connectivity status', error: e);
      return;
    }

    return updateConnectionStatus(result);
  }

  Future<void> updateConnectionStatus(List<ConnectivityResult> result) async {
    connectionStatus = result;
    debugPrint('212121 changed $result');
    //  ScaffoldMessenger.of(navigatorKey.currentState!.context).hideCurrentSnackBar();

    if (connectionStatus.contains(ConnectivityResult.none)) {
      /*    showSnackBar(
          message: NoInternetConnection().error);*/
      currentContext = navigatorKey.currentState?.context;
      if (currentContext != null) {
        Navigator.pushNamed(currentContext!, AppRoutes.noInternetScreen);
      }
    } else {
      if (currentContext != null && Navigator.canPop(currentContext!)) {
        Navigator.pop(currentContext!);
        currentContext = null;
      }

      // showSnackBar(message: translate(AppStringsKey.internetIsBack), bgColor: Colors.green);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    connectivitySubscription.cancel();
  }
}

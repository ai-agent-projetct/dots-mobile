import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:user/utils/helpers/common_utils.dart';
import 'package:user/utils/services/prefs.dart';

// class MapsProvider extends ChangeNotifier {
//   Completer<GoogleMapController> controller = Completer<GoogleMapController>();
//   GoogleMapController? googleMapController;

//   LatLng currentLatLng = Prefs().getLastKnownLatLng();

//   String? currentAddress;

//   MapsProvider() {
//     getCurrentPosition();
//   }

//   Future<void> getCurrentPosition() async {
//     bool permissionAvailable = await CommonUtils.checkLocationPermission();
//     if (!permissionAvailable) return;

//     try {
//       // Step 1: Get last known location instantly
//       Position? lastPos = await Geolocator.getLastKnownPosition();
//       if (lastPos != null) {
//         currentLatLng = LatLng(lastPos.latitude, lastPos.longitude);
//         notifyListeners();
//       }

//       // Step 2: Fetch accurate GPS location in background
//       Position currentPosition = await Geolocator.getCurrentPosition(
//         locationSettings: const LocationSettings(
//           accuracy: LocationAccuracy.high,
//         ),
//       );
//       currentLatLng = LatLng(
//         currentPosition.latitude,
//         currentPosition.longitude,
//       );
//       await updateCurrentAddress();
//       notifyListeners();
//     } catch (e) {
//       debugPrint("Error getting current position: $e");
//     }
//   }

//   /// Properly dispose and reset controller when leaving map screen
//   void resetController() {
//     googleMapController?.dispose();
//     googleMapController = null;
//     controller = Completer<GoogleMapController>(); // new instance
//   }

//   /// Fetch place name from coordinates
//   Future<void> updateCurrentAddress() async {
//     try {
//       final placemarks = await placemarkFromCoordinates(
//         currentLatLng.latitude,
//         currentLatLng.longitude,
//       );

//       if (placemarks.isNotEmpty) {
//         final subLocality = placemarks.first.subLocality?.trim();
//         final locality = placemarks.first.locality?.trim();

//         currentAddress =
//             (subLocality != null && subLocality.isNotEmpty)
//                 ? subLocality
//                 : (locality != null && locality.isNotEmpty)
//                 ? locality
//                 : 'Unknown place';
//       } else {
//         currentAddress = 'Unknown place';
//       }
//     } catch (e) {
//       debugPrint("Error getting place: $e");
//       currentAddress = 'Unknown place';
//     }
//     notifyListeners();
//   }
// }

class MapsProvider extends ChangeNotifier {
  Completer<GoogleMapController> controller = Completer<GoogleMapController>();
  GoogleMapController? googleMapController;

  LatLng currentLatLng = Prefs().getLastKnownLatLng();
  String? currentAddress;

  MapsProvider() {
    getCurrentPosition();
  }

  /// Get current position and return updated LatLng
  Future<LatLng?> getCurrentPosition() async {
    bool permissionAvailable = await CommonUtils.checkLocationPermission();
    if (!permissionAvailable) return null;

    try {
      // Step 1: Get last known location instantly
      Position? lastPos = await Geolocator.getLastKnownPosition();
      if (lastPos != null) {
        currentLatLng = LatLng(lastPos.latitude, lastPos.longitude);
        notifyListeners();
      }

      // Step 2: Fetch accurate GPS location
      Position currentPosition = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      currentLatLng = LatLng(
        currentPosition.latitude,
        currentPosition.longitude,
      );

      await updateCurrentAddress();
      notifyListeners();
      return currentLatLng; // ✅ return fresh LatLng
    } catch (e) {
      debugPrint("Error getting current position: $e");
      return null;
    }
  }

  /// Properly dispose and reset controller when leaving map screen
  void resetController() {
    googleMapController?.dispose();
    googleMapController = null;
    controller = Completer<GoogleMapController>();
  }

  /// Fetch place name from coordinates
  Future<void> updateCurrentAddress() async {
    try {
      final placemarks = await placemarkFromCoordinates(
        currentLatLng.latitude,
        currentLatLng.longitude,
      );

      if (placemarks.isNotEmpty) {
        final subLocality = placemarks.first.subLocality?.trim();
        final locality = placemarks.first.locality?.trim();

        currentAddress =
            (subLocality != null && subLocality.isNotEmpty)
                ? subLocality
                : (locality != null && locality.isNotEmpty)
                ? locality
                : 'Unknown place';
      } else {
        currentAddress = 'Unknown place';
      }
    } catch (e) {
      debugPrint("Error getting place: $e");
      currentAddress = 'Unknown place';
    }
    notifyListeners();
  }
}

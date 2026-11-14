import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/constants/app_colors.dart';
import 'package:provider/constants/app_images.dart';
import 'package:provider/constants/app_strings.dart';
import 'package:provider/utils/helpers/common_utils.dart';
import 'package:provider/widgets/app_button.dart';
import 'package:provider/widgets/app_text_field.dart';
import 'package:resize/resize.dart';

class LocationPickerScreen extends ConsumerStatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  ConsumerState<LocationPickerScreen> createState() =>
      _LocationPickerScreenState();
}

class _LocationPickerScreenState extends ConsumerState<LocationPickerScreen> {
  GoogleMapController? _mapController;
  bool _loading = true;

  final addressLine1Controller = TextEditingController();
  final addressLine2Controller = TextEditingController();
  final cityStateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _setInitialLocation();
  }

  /// Get current location
  Future<void> _setInitialLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    Position position = await Geolocator.getCurrentPosition();
    final currentLocation = LatLng(position.latitude, position.longitude);

    if (mounted) {
      ref.read(locationProvider.notifier).setLocation(currentLocation);
      await _updateAddressFields(currentLocation);
      setState(() => _loading = false);
    }
  }

  /// Update address fields when pin moves
  Future<void> _updateAddressFields(LatLng position) async {
    final placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isNotEmpty) {
      final place = placemarks.first;

      // Helper function to clean nulls and empty strings
      String clean(List<String?> parts) {
        return parts.where((e) => e != null && e.trim().isNotEmpty).join(", ");
      }

      addressLine1Controller.text = clean([place.name, place.street]);

      addressLine2Controller.text = clean([place.subLocality, place.locality]);

      cityStateController.text = clean([
        place.subAdministrativeArea,
        place.administrativeArea,
        place.postalCode,
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pickedLocation = ref.watch(locationProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Pin Location")),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : Stack(
                children: [
                  /// Google Map
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: pickedLocation,
                      zoom: 14,
                    ),
                    onMapCreated: (controller) {
                      _mapController = controller;
                    },
                    markers: {
                      Marker(
                        markerId: const MarkerId('picked'),
                        position: pickedLocation,
                        draggable: true,
                        onDragEnd: (newPosition) async {
                          ref
                              .read(locationProvider.notifier)
                              .setLocation(newPosition);
                          await _updateAddressFields(newPosition);
                        },
                      ),
                    },
                    onTap: (position) async {
                      ref.read(locationProvider.notifier).setLocation(position);
                      await _updateAddressFields(position);
                    },
                  ),

                  /// Bottom Editable Fields
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: addressLine1Controller,
                            style: TextStyle(
                              color: AppColors.black,
                              fontWeight: FontWeight.w400,
                              fontFamily: AppStringsKey.poppins,
                              fontSize: 12.sp,
                            ),
                            cursorColor: AppColors.primary,

                            decoration: InputDecoration(
                              labelText: "Door No / Street",
                              labelStyle: TextStyle(
                                color: AppColors.hintColor,
                                fontWeight: FontWeight.w300,
                                fontSize: 12.sp,
                              ),
                              filled: true,
                              fillColor: AppColors.backGroundGrey,
                              border: getBorder(),
                              focusedBorder: getEnabledBorder(),
                              enabledBorder: getBorder(),
                            ),
                          ),

                          const SizedBox(height: 8),
                          TextField(
                            controller: addressLine2Controller,
                            style: TextStyle(
                              color: AppColors.black,
                              fontWeight: FontWeight.w400,
                              fontFamily: AppStringsKey.poppins,
                              fontSize: 12.sp,
                            ),
                            decoration: InputDecoration(
                              labelText: "Area / Locality",
                              labelStyle: TextStyle(
                                color: AppColors.hintColor,
                                fontWeight: FontWeight.w300,
                                fontSize: 12.sp,
                              ),
                              filled: true,
                              fillColor: AppColors.backGroundGrey,
                              border: getBorder(),
                              focusedBorder: getEnabledBorder(),
                              enabledBorder: getBorder(),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: cityStateController,
                            style: TextStyle(
                              color: AppColors.black,
                              fontWeight: FontWeight.w400,
                              fontFamily: AppStringsKey.poppins,
                              fontSize: 12.sp,
                            ),
                            decoration: InputDecoration(
                              labelText: "City, District & State",
                              labelStyle: TextStyle(
                                color: AppColors.hintColor,
                                fontWeight: FontWeight.w300,
                                fontSize: 12.sp,
                              ),
                              filled: true,
                              fillColor: AppColors.backGroundGrey,
                              border: getBorder(),
                              focusedBorder: getEnabledBorder(),
                              enabledBorder: getBorder(),
                            ),
                          ),
                          const SizedBox(height: 12),
                          AppPrimaryButton(
                            text: "Confirm Location",
                            textSize: 16.sp,
                            onTap: () {
                              CommonUtils.hideKeyBoard(context);
                              final selectedLocation = ref.read(
                                locationProvider,
                              );
                              final fullAddress =
                                  "${addressLine1Controller.text}, ${addressLine2Controller.text}, ${cityStateController.text}";

                              Navigator.pop(context, {
                                'address': fullAddress,
                                'latLng': selectedLocation,
                              });
                            },
                          ),
                          // ElevatedButton.icon(
                          //   style: ElevatedButton.styleFrom(
                          //     backgroundColor: AppColors.primary,
                          //     minimumSize: const Size(double.infinity, 48),
                          //   ),
                          //   icon: const Icon(
                          //     Icons.location_pin,
                          //     color: Colors.white,
                          //   ),
                          //   label: const Text(
                          //     "Confirm Location",
                          //     style: TextStyle(
                          //       color: Colors.white,
                          //       fontWeight: FontWeight.bold,
                          //     ),
                          //   ),
                          //   onPressed: () {
                          //     final selectedLocation = ref.read(
                          //       locationProvider,
                          //     );
                          //     final fullAddress =
                          //         "${addressLine1Controller.text}, ${addressLine2Controller.text}, ${cityStateController.text}";

                          //     Navigator.pop(context, {
                          //       'address': fullAddress,
                          //       'latLng': selectedLocation,
                          //     });
                          //   },
                          // ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
    );
  }
}

class LocationNotifier extends StateNotifier<LatLng> {
  LocationNotifier()
    : super(const LatLng(12.9716, 77.5946)); // Default Bangalore

  void setLocation(LatLng location) {
    state = location;
  }
}

final locationProvider = StateNotifierProvider<LocationNotifier, LatLng>(
  (ref) => LocationNotifier(),
);

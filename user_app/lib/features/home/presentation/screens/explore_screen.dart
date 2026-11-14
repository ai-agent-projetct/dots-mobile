import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sliding_up_panel/sliding_up_panel_widget.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:resize/resize.dart';
import 'package:user/config/app_routes.dart';
import 'package:user/constants/app_colors.dart';
import 'package:user/constants/app_constants.dart';
import 'package:user/constants/app_images.dart';
import 'package:user/di/di.dart';
import 'package:user/features/home/presentation/provider/explore_provider.dart';
import 'package:user/features/home/presentation/provider/maps_provider.dart';
import 'package:user/features/home/presentation/widgets/right_corner_button.dart';
import 'package:user/features/home/presentation/widgets/search_and_services_widget.dart';
import 'package:user/features/home/presentation/widgets/slidingup_panel_widget.dart';
import 'package:user/utils/services/prefs.dart';
import 'package:user/widgets/app_text.dart';
import 'package:user/widgets/loading_widget.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ExploreScreenState createState() => ExploreScreenState();
}

class ExploreScreenState extends ConsumerState<ExploreScreen>
    with WidgetsBindingObserver {
  DateTime? currentBackPressTime;
  final SlidingUpPanelController _panelController = SlidingUpPanelController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(exploreProvider).clearProviders();
        ref.read(exploreProvider).getSubCtaegoryList().then((_) {
          _centerMapAfterMarkersLoad();
        });
        ref.read(profileProvider).loadPrefs();
        ref.read(exploreProvider).getDashboard();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _centerMapAfterMarkersLoad() async {
    if (!mounted) return; // don't run if widget is gone

    final mMapsProvider = ref.read(mapsProvider);
    final mExploreProvider = ref.read(exploreProvider);

    // Ensure controller exists
    if (!mMapsProvider.controller.isCompleted) return;
    final controller = await mMapsProvider.controller.future;

    if (!mounted) return; // double-check after await

    try {
      if (mExploreProvider.providersList.isNotEmpty) {
        final firstProvider = mExploreProvider.providersList.first;
        if (firstProvider.latitude != null && firstProvider.longitude != null) {
          await controller.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(
                  double.tryParse(firstProvider.latitude.toString()) ?? 0.0,
                  double.tryParse(firstProvider.longitude.toString()) ?? 0.0,
                ),
                zoom: 15,
              ),
            ),
          );
          return;
        }
      }

      // fallback to current location
      if (mMapsProvider.currentLatLng != const LatLng(0, 0)) {
        await controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: mMapsProvider.currentLatLng, zoom: 15),
          ),
        );
      }
    } catch (e) {
      // Map may be disposed; just ignore
      log("Map animate error-----: $e");
    }
  }

  void _onMarkerTapped(String providerId, String subcategoryId) {
    Navigator.pushNamed(
      context,
      AppRoutes.providerDetails,
      arguments: {'providerId': providerId, 'subcategoryId': subcategoryId},
    );
  }

  @override
  Widget build(BuildContext context) {
    final mMapsProvider = ref.watch(mapsProvider);
    final mExploreProvider = ref.watch(exploreProvider);
    log("ExploreScreen");

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (_showBackDialog()) {
          exit(0);
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: SizedBox(
          height: 100.vh,
          width: 100.vw,
          child: Stack(
            children: [
              (mMapsProvider.currentLatLng != const LatLng(0, 0))
                  ? GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: mMapsProvider.currentLatLng,
                      zoom: 15,
                    ),
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    zoomGesturesEnabled: true,
                    zoomControlsEnabled: false,
                    scrollGesturesEnabled: true,
                    rotateGesturesEnabled: false,
                    mapType: MapType.normal,
                    padding: EdgeInsets.only(
                      bottom: 30.h,
                      left: 60.w,
                      right: 60.w,
                    ),
                    markers: {
                      for (final provider in mExploreProvider.providersList)
                        if (provider.latitude != null &&
                            provider.longitude != null &&
                            provider.latitude.toString().isNotEmpty &&
                            provider.longitude.toString().isNotEmpty)
                          Marker(
                            markerId: MarkerId(provider.providerID.toString()),
                            position: LatLng(
                              double.tryParse(provider.latitude.toString()) ??
                                  0.0,
                              double.tryParse(provider.longitude.toString()) ??
                                  0.0,
                            ),
                            onTap: () {
                              log(
                                provider
                                    .subCategoryResponseModel!
                                    .subCategoryId,
                              );
                              _onMarkerTapped(
                                provider.providerID.toString(),
                                provider.subCategoryResponseModel!.subCategoryId
                                    .toString(),
                              );
                            },
                          ),
                    },
                    onMapCreated: (GoogleMapController controller) {
                      if (!mMapsProvider.controller.isCompleted) {
                        mMapsProvider.controller.complete(controller);
                      }
                      mMapsProvider.googleMapController = controller;

                      _centerMapAfterMarkersLoad();
                    },
                  )
                  : const LoadingWidget(),

              // Search & Services
              Positioned(
                top: AppConstants.appBarHeight - 20.h,
                left: 0,
                right: 0,
                child: const SearchAndServicesWidget(),
              ),

              // Right Floating Menu
              Positioned(
                bottom: mExploreProvider.floatingBottomPosition,
                right: 10.w,
                child: Column(
                  children: [
                    RightCornerButton(
                      routes: AppRoutes.categoryScreen,
                      image: AppImages.menu,
                    ),
                    SizedBox(height: 10.h),
                  ],
                ),
              ),
              // Inside Stack's children, after SlidingPanelWidget
              Positioned(
                bottom:
                    mExploreProvider.floatingBottomPosition +
                    60.h, // above right corner menu
                right: 10.w,
                child: InkWell(
                  onTap: () async {
                    final mMapsProvider = ref.read(mapsProvider);

                    // 1. Use last known immediately
                    Position? lastPos = await Geolocator.getLastKnownPosition();
                    if (lastPos != null &&
                        mMapsProvider.controller.isCompleted) {
                      final controller = await mMapsProvider.controller.future;
                      controller.moveCamera(
                        CameraUpdate.newLatLngZoom(
                          LatLng(lastPos.latitude, lastPos.longitude),
                          17,
                        ),
                      );
                    }

                    // 2. Meanwhile fetch fresh location in background
                    final newPosition =
                        await mMapsProvider.getCurrentPosition();
                    if (newPosition != null &&
                        mMapsProvider.controller.isCompleted) {
                      final controller = await mMapsProvider.controller.future;
                      controller.animateCamera(
                        CameraUpdate.newLatLngZoom(newPosition, 17),
                      );
                    }
                  },
                  child: Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.5),
                          blurRadius: 5.r,
                          spreadRadius: 1.r,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Center(
                      child: const Icon(Icons.my_location, color: Colors.blue),
                    ),
                  ),
                ),
              ),

              // Sliding Panel
              const SlidingPanelWidget(),
            ],
          ),
        ),
      ),
    );
  }

  bool _showBackDialog() {
    final now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 1)) {
      currentBackPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.r)),
          ),
          width: 150.w,
          content: const AppText(
            'Press again to exit',
            textAlign: TextAlign.center,
            textColor: AppColors.white,
          ),
        ),
      );
      return false;
    }
    return true;
  }
}

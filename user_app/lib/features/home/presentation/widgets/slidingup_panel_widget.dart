import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sliding_up_panel/sliding_up_panel_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:resize/resize.dart';
import 'package:user/constants/app_strings.dart';
import 'package:user/di/di.dart';
import 'package:user/features/home/presentation/provider/home_provider.dart';
import 'package:user/features/home/presentation/widgets/offersection_slidepanel.dart';
import 'package:user/features/home/presentation/widgets/tradesection_slidepanel.dart';
import 'package:user/features/home/presentation/widgets/trendsection_slipdepanel.dart';
import 'package:user/utils/helpers/common_utils.dart';
import 'package:user/widgets/show_snackbar.dart';

class SlidingPanelWidget extends ConsumerStatefulWidget {
  const SlidingPanelWidget({super.key});

  @override
  SlidingPanelWidgetState createState() => SlidingPanelWidgetState();
}

class SlidingPanelWidgetState extends ConsumerState<SlidingPanelWidget> {
  late ScrollController _localScrollController;
  late final SlidingUpPanelController _panelController;

  @override
  void initState() {
    super.initState();
    _localScrollController = ScrollController();
    _panelController = SlidingUpPanelController();

    final explore = ref.read(exploreProvider);
    explore.floatingBottomPosition =
        (explore.minChildSize + 0.005) * ResizeUtil().screenHeight;

    _localScrollController.addListener(() {
      final offset = _localScrollController.offset;
      final position = _localScrollController.position;

      try {
        if (offset >= position.maxScrollExtent && !position.outOfRange) {
          _panelController.expand();
        } else if (offset <= position.minScrollExtent && !position.outOfRange) {
          _panelController.anchor();
        }
      } catch (e) {
        debugPrint('Panel controller call failed: $e');
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Force close on init
      try {
        _panelController.collapse();
      } catch (e) {
        debugPrint("Error collapsing panel: $e");
      }

      if (!mounted) return;
      final maps = ref.read(mapsProvider);
      await ref.read(mapsProvider).getCurrentPosition();

      final latLng = maps.currentLatLng;

      print('Current LatLng: $latLng');
      if (latLng != LatLng(0, 0)) {
        await ref
            .read(homeProvider)
            .getAllOffers(latLng.latitude, latLng.longitude);
        await ref
            .read(trendsProvider)
            .getAllTrends(latLng.latitude, latLng.longitude);
      } else {
        // showSnackBar(message: 'Location not available');
      }
      ref.read(tradeProvider).fetchAllTrades();
    });
  }

  @override
  void dispose() {
    _localScrollController.dispose();
    super.dispose();
  }

  void _handlePanelTap() {
    try {
      final status = _panelController.status;
      if (status == SlidingUpPanelStatus.expanded) {
        _panelController.anchor();
      } else if (status == SlidingUpPanelStatus.anchored) {
        _panelController.collapse();
      } else if (status == SlidingUpPanelStatus.collapsed) {
        _panelController.anchor();
      }
    } catch (e) {
      debugPrint("Error handling panel tap: $e");
    }
  }

  void _handleStatusChange(SlidingUpPanelStatus status) {
    final explore = ref.read(exploreProvider);
    if (status == SlidingUpPanelStatus.collapsed) {
      explore.floatingBottomPosition =
          (explore.minChildSize + 0.005) * ResizeUtil().screenHeight;
    } else {
      explore.floatingBottomPosition =
          (explore.initialChildSize - 0.05) * ResizeUtil().screenHeight;
    }
    explore.notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<HomeProvider>(homeProvider, (previous, next) {
      if (next.bottomIndex == 0 && mounted) {
        try {
          _panelController.collapse();
          final explore = ref.read(exploreProvider);
          explore.floatingBottomPosition =
              (explore.minChildSize + 0.005) * ResizeUtil().screenHeight;
          explore.notifyListeners();
        } catch (e) {
          debugPrint("Error collapsing panel: $e");
        }
      }
    });

    var mExploreProvider = ref.watch(exploreProvider);
    var mapsprovider = ref.watch(mapsProvider);

    return SlidingUpPanelWidget(
      controlHeight: 50.0.h,
      anchor: mExploreProvider.initialChildSize,
      minimumBound: mExploreProvider.minChildSize,
      upperBound: mExploreProvider.maxChildSize,
      panelController: _panelController,
      panelStatus: SlidingUpPanelStatus.collapsed, // Start closed
      onTap: () {
        CommonUtils.hideKeyBoard(context);
        _handlePanelTap();
      },
      onStatusChanged: (status) {
        CommonUtils.hideKeyBoard(context);
        _handleStatusChange(status);
      },
      enableOnTap: true,
      child: Container(
        decoration: ShapeDecoration(
          color: Colors.white,
          shadows: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.5),
              blurRadius: 5.r,
              spreadRadius: 1.r,
              offset: const Offset(0, 0),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0.r),
              topRight: Radius.circular(20.0.r),
            ),
          ),
        ),
        child: Column(
          children: <Widget>[
            SizedBox(height: 10.h),
            Container(
              alignment: Alignment.center,
              width: 50.w,
              height: 5.h,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(5.r),
              ),
            ),
            //SizedBox(height: 15.h),
            Flexible(
              child: ScrollConfiguration(
                behavior: NoOverscrollBehavior(),
                child: ListView(
                  controller: _localScrollController,
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  children: [
                    if (mapsprovider.currentAddress != null)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        child: Row(
                          children: [
                            Icon(
                              Icons.place,
                              color: Colors.blueAccent,
                              size: 20.sp,
                            ),
                            SizedBox(width: 5.w),
                            Expanded(
                              child: Text(
                                mapsprovider.currentAddress ??
                                    'Fetching location...',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                  fontFamily: AppStringsKey.poppins,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),

                    const OffersSection(),
                    SizedBox(height: 20),
                    const TrendsSection(),
                    SizedBox(height: 20),
                    const TradeSection(),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NoOverscrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}

class NoScrollGlow extends ScrollBehavior {
  Widget buildViewportChrome(
    BuildContext context,
    Widget child,
    AxisDirection axisDirection,
  ) {
    return child;
  }
}

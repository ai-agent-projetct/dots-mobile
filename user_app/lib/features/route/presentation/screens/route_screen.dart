import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:resize/resize.dart';
import 'package:user/constants/app_colors.dart';
import 'package:user/constants/app_constants.dart';
import 'package:user/constants/app_images.dart';
import 'package:user/constants/app_strings.dart';
import 'package:user/di/di.dart';
import 'package:user/widgets/app_bar.dart';
import 'package:user/widgets/app_text.dart';
import 'package:user/widgets/app_text_field.dart';
import 'package:user/widgets/loading_widget.dart';

class RouteScreen extends ConsumerStatefulWidget {
  const RouteScreen({super.key});

  @override
  RouteScreenState createState() => RouteScreenState();
}

class RouteScreenState extends ConsumerState<RouteScreen> {
  @override
  Widget build(BuildContext context) {
    var mRouteProvider = ref.watch(routeProvider);
    var mMapsProvider = ref.watch(mapsProvider);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        debugPrint('pop scope called from routes screen ---- $didPop');
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        resizeToAvoidBottomInset: true,
        extendBodyBehindAppBar: true,
        extendBody: false,
        body: SizedBox(
          height: 100.vh,
          width: 100.vw,
          child: Stack(
            children: [
              mMapsProvider.currentLatLng != LatLng(0, 0)
                  ? GoogleMap(
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    zoomGesturesEnabled: true,
                    zoomControlsEnabled: false,
                    rotateGesturesEnabled: false,
                    scrollGesturesEnabled: true,
                    mapType: MapType.normal,
                    padding: EdgeInsets.only(
                      bottom: 30.h,
                      left: 60.w,
                      right: 60.w,
                    ),
                    buildingsEnabled: true,
                    initialCameraPosition: CameraPosition(
                      target: mMapsProvider.currentLatLng,
                      zoom: 17,
                    ),
                    onMapCreated: (GoogleMapController controller) {
                      if (!mMapsProvider.controller.isCompleted) {
                        mMapsProvider.controller.complete(controller);
                      }
                      mMapsProvider.googleMapController = controller;
                      setState(() {});
                    },
                  )
                  : LoadingWidget(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SizedBox(
                  //   height: AppConstants.safeAreaHeight,
                  // ),
                  CustomAppBar(
                    title: translate(AppStringsKey.routeText),
                    leadingIconHeight: 22.5.h,
                    textSize: 16.sp,
                    showLeadingIcon: true,
                    leadingIconEnabled: true,
                    onTap: () {
                      ref.read(homeProvider).onItemTap(0);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 10.w,
                      right: 10.w,
                      bottom: 10.h,
                    ),
                    child: SizedBox(
                      width: ResizeUtil().screenWidth,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFEAEAEA),
                                borderRadius: BorderRadius.circular(20.0.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 0.8.r,
                                    spreadRadius: 0.8.r,
                                    offset: Offset(0, 0),
                                  ),
                                ],
                              ),
                              child: PrimaryTextField(
                                mRouteProvider.searchController,
                                hint: "Search Route...",
                                fillColor: const Color(0xFFEAEAEA),
                                contentPadding: EdgeInsets.only(left: 40.w),
                                inputBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0.r),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFEAEAEA),
                                  ),
                                ),
                                prefixIcon: Padding(
                                  padding: EdgeInsets.only(
                                    left: 10.w,
                                    right: 10.w,
                                  ),
                                  child: Icon(Icons.search),
                                ),
                                prefixIconConstraints: BoxConstraints(
                                  maxHeight: 20.h,
                                  maxWidth: 50.w,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10.w),
                            child: Image.asset(
                              AppImages.filter,
                              fit: BoxFit.cover,
                              width: 25.w,
                              height: 25.h,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 35.h,
                    width: ResizeUtil().screenWidth,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount:
                          mRouteProvider.vehicleRoutes.length > 7
                              ? 8
                              : mRouteProvider.vehicleRoutes.length,
                      padding: EdgeInsets.only(left: 10.w),
                      itemBuilder: (context, index) {
                        if (index == 7 &&
                            mRouteProvider.vehicleRoutes.length > 7) {
                          return InkWell(
                            onTap: () {},
                            child: Container(
                              width: 120.w,
                              height: 40.h,
                              margin: EdgeInsets.only(right: 10.0.w),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEAEAEA),
                                borderRadius: BorderRadius.circular(20.0.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 0.8,
                                    spreadRadius: 0.8,
                                    offset: Offset(0, 0),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.more_horiz, size: 20.sp),
                                  SizedBox(width: 5.w),
                                  Flexible(
                                    child: AppText(
                                      'More',
                                      textSize: 12.sp,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        final item = mRouteProvider.vehicleRoutes[index];
                        return InkWell(
                          onTap: () {},
                          child: Container(
                            width: 120.w,
                            margin: EdgeInsets.only(right: 10.0.w),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEAEAEA),
                              borderRadius: BorderRadius.circular(20.0.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 0.8,
                                  spreadRadius: 0.8,
                                  offset: Offset(0, 0),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  child: Image.asset(
                                    item['image'].toString(),
                                    fit: BoxFit.cover,
                                    height: 20.h,
                                    width: 20.w,
                                  ),
                                ),
                                // AppNetworkImage(
                                //   url: item['image'].toString(),
                                //   height: 20.h,
                                //   width: 20.w,
                                //   fit: BoxFit.cover,
                                // ),
                                SizedBox(width: 5.w),
                                Flexible(
                                  child: AppText(
                                    item['name'].toString(),
                                    textSize: 11.sp,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

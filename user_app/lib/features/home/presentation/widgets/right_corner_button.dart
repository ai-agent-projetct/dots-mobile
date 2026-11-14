import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resize/resize.dart';
import 'package:user/config/app_routes.dart';
import 'package:user/constants/app_colors.dart';
import 'package:user/constants/app_images.dart';
import 'package:user/di/di.dart';

class RightCornerButton extends ConsumerWidget {
  const RightCornerButton({
    required this.routes,
    required this.image,
    super.key,
  });

  final String routes;
  final String image;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        if (routes.isNotEmpty) {
          if (routes != AppRoutes.pollScreen) {
            ref.read(exploreProvider).clearProviders();
            debugPrint('list --> ${ref.read(exploreProvider).dasboardData}');
            Navigator.pushNamed(
              context,
              routes,
              arguments: {
                'dashboardData': ref.read(exploreProvider).dasboardData,
              },
            );
          } else {
            Navigator.pushNamed(context, routes);
          }
        } else {
          if (image == AppImages.currentLocation) {
            ref.read(mapsProvider).getCurrentPosition();
          }
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
          child: Image.asset(
            image,
            fit: BoxFit.contain,
            color: AppColors.blackColor,
            width: 20.w,
            height: 20.h,
          ),
        ),
      ),
    );
  }
}

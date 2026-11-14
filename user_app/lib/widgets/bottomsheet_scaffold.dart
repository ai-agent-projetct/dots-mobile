import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resize/resize.dart';
import 'package:user/constants/app_colors.dart';
import 'package:user/constants/app_constants.dart';

class BottomSheetScaffold extends ConsumerWidget {
  final Widget child;
  const BottomSheetScaffold({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: ResizeUtil().screenWidth,
          padding: EdgeInsets.symmetric(
              horizontal: AppConstants.screenWidth * 0.05,
              vertical: AppConstants.screenHeight * 0.03),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18.0.r),
              topRight: Radius.circular(18.0.r),
            ),
          ),
          child: child,
        ),
      ],
    );
  }
}

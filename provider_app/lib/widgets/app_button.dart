import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/constants/app_colors.dart';
import 'package:provider/constants/app_constants.dart';
import 'package:provider/constants/app_strings.dart';
import 'package:provider/widgets/app_text.dart';
import 'package:resize/resize.dart';

// ignore: must_be_immutable
class AppPrimaryButton extends ConsumerWidget {
  AppPrimaryButton({
    super.key,
    required this.text,
    this.textColor = AppColors.white,
    this.textSize = 14.0,
    this.fontFamily,
    this.fontWeight = FontWeight.w500,
    this.decoration,
    this.backgroundColor,
    this.showLoader = false,
    this.height,
    required this.onTap,
  });

  String text;
  Color? textColor;
  final double? textSize;
  final String? fontFamily;
  FontWeight fontWeight;
  Decoration? decoration;
  Color? backgroundColor;
  bool showLoader;
  final double? height;
  void Function()? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: showLoader ? null : onTap,
      child: Container(
        height: height ?? AppConstants.screenHeight * 0.06,
        decoration:
            decoration ??
            BoxDecoration(
              borderRadius: BorderRadius.circular(5.0.r),
              color: backgroundColor ?? AppColors.primary,
            ),
        child: Center(
          child:
              showLoader
                  ? const LoadingIndicator(
                    indicatorType: Indicator.ballPulse,
                    colors: [AppColors.white],
                  )
                  : AppText(
                    text,
                    fontWeight: fontWeight,
                    fontFamily: fontFamily ?? AppStringsKey.poppins,
                    textSize: textSize,
                    textColor: textColor,
                  ),
        ),
      ),
    );
  }
}

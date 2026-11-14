import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:user/constants/app_colors.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({this.isOverLay = false, this.size = 60.0, super.key});
  final bool isOverLay;
  final double size;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isOverLay ? () {} : null,
      child: Container(
        height: isOverLay ? double.infinity : null,
        width: isOverLay ? double.infinity : null,
        color: isOverLay ? AppColors.black.withValues(alpha: 0.1) : null,
        child: Center(
            child: SizedBox(
          height: size,
          width: size,
          child: const LoadingIndicator(
            indicatorType: Indicator.ballSpinFadeLoader,
            colors: [AppColors.primary],
          ),
        )),
      ),
    );
  }
}

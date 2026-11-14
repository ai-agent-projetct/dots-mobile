import 'package:flutter/material.dart';
import 'package:provider/constants/app_colors.dart';

Widget horizontalSeparatorWidget({
  double height = 1,
  Color color = AppColors.greyStroke,
  double horizontalMargin = 0,
}) {
  return Container(
    height: height,
    color: color,
    margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
  );
}

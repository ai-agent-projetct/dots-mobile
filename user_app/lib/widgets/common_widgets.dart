import 'package:flutter/material.dart';
import 'package:resize/resize.dart';
import 'package:user/constants/app_colors.dart';

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

Widget buildNoImageWidget() {
  return Container(
    height: 100.h,
    width: double.infinity,
    color: Colors.grey.shade200,
    alignment: Alignment.center,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.broken_image, color: Colors.grey, size: 30),
        SizedBox(height: 4),
        Text(
          "Unavailable",
          style: TextStyle(color: Colors.grey, fontSize: 11.sp),
        ),
      ],
    ),
  );
}

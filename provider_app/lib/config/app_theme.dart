import 'package:flutter/material.dart';
import 'package:provider/constants/app_colors.dart';
import 'package:provider/constants/app_strings.dart';
import 'package:resize/resize.dart';

class AppTheme {
  final ThemeData themeData = ThemeData(
    fontFamily: AppStringsKey.poppins,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color>((
          Set<WidgetState> states,
        ) {
          return AppColors.primary;
        }),
        textStyle: WidgetStateProperty.resolveWith<TextStyle>((
          Set<WidgetState> states,
        ) {
          return TextStyle(
            fontSize: 13.sp,
            color: AppColors.white,
            fontWeight: FontWeight.w500,
          ); // Use the component's default.
        }),
      ),
    ),
  );

  TextStyle bold900(double fontSize, {Color? color, double? height}) =>
      TextStyle(
        fontSize: fontSize.sp,
        height: height,
        fontWeight: FontWeight.w900,
        color: color ?? AppColors.black,
      );

  TextStyle bold800(double fontSize, {Color? color, double? height}) =>
      TextStyle(
        fontSize: fontSize.sp,
        height: height,
        fontWeight: FontWeight.w800,
        color: color ?? AppColors.black,
      );

  TextStyle bold700(
    double fontSize, {
    Color? color,
    double? height,
    TextDecoration? textDecoration,
  }) => TextStyle(
    fontSize: fontSize.sp,
    height: height,
    decoration: textDecoration,
    fontWeight: FontWeight.w700,
    color: color ?? AppColors.black,
  );

  TextStyle bold600(double fontSize, {Color? color, double? height}) =>
      TextStyle(
        fontSize: fontSize.sp,
        height: height,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.black,
      );

  TextStyle normal500(double fontSize, {Color? color, double? height}) =>
      TextStyle(
        fontSize: fontSize.sp,
        fontWeight: FontWeight.w500,
        height: height,
        color: color ?? AppColors.black,
      );

  TextStyle normal400(double fontSize, {Color? color, double? height}) =>
      TextStyle(
        fontSize: fontSize.sp,
        fontWeight: FontWeight.w400,
        height: height,
        color: color ?? AppColors.black,
      );

  InputDecoration searchField({String? hintText}) => InputDecoration(
    hintText: hintText,
    hintStyle: normal400(12.sp, color: AppColors.hintTextGrey),
    enabledBorder: InputBorder.none,
    focusedBorder: InputBorder.none,
    border: InputBorder.none,
  );
}

import 'package:flutter/material.dart';
import 'package:provider/constants/app_colors.dart';
import 'package:provider/main.dart';

void showSnackBar({
  BuildContext? context,
  required String message,
  int seconds = 2,
  Color? bgColor,
}) {
  final snackBar = SnackBar(
    behavior: SnackBarBehavior.floating,
    dismissDirection: DismissDirection.horizontal,
    backgroundColor: bgColor ?? AppColors.black,
    duration: Duration(seconds: seconds),
    content: InkWell(
      onTap: () {
        hideSnackBar();
      },
      child: Text(
        message,
        style: const TextStyle(color: Colors.white),
        textAlign: TextAlign.left,
      ),
    ),
  );
  final scaffoldMessenger = ScaffoldMessenger.of(
    navigatorKey.currentState!.context,
  );

  ScaffoldMessenger.of(navigatorKey.currentState!.context)
      .showSnackBar(snackBar)
      .closed
      .then((value) => scaffoldMessenger.clearSnackBars());
}

void hideSnackBar() {
  ScaffoldMessenger.of(
    navigatorKey.currentState!.context,
  ).hideCurrentSnackBar();
}

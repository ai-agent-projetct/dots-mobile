import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/constants/app_colors.dart';
import 'package:provider/constants/app_strings.dart';

class AppText extends ConsumerWidget {
  final String? data;
  final Color? textColor;
  final TextStyle? textStyle;
  final String? fontFamily;
  final double? textSize;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Color? decorationColor;
  final TextDecoration textDecoration;
  final Locale? locale;
  final bool? softWrap;
  final TextOverflow? overflow;
  final int? maxLines;
  final String? semanticsLabel;
  final double? letterspacing;
  final double? lineHeight;
  final EdgeInsets? padding;

  const AppText(
    String this.data, {
    super.key,
    this.textColor,
    this.textStyle,
    this.fontFamily,
    this.textSize,
    this.fontWeight,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.textDecoration = TextDecoration.none,
    this.decorationColor,
    this.locale,
    this.softWrap,
    this.overflow,
    this.maxLines,
    this.semanticsLabel,
    this.letterspacing,
    this.lineHeight,
    this.padding,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: padding ?? EdgeInsets.all(0),
      child: Text(
        data.toString(),
        style: getStyle(),
        textAlign: textAlign,
        textDirection: textDirection,
        locale: locale,
        softWrap: softWrap,
        overflow: overflow,
        maxLines: maxLines,
        semanticsLabel: semanticsLabel,
      ),
    );
  }

  TextStyle getStyle() =>
      textStyle ??
      TextStyle(
        color: textColor ?? AppColors.secondary,
        fontSize: textSize,
        height: lineHeight,
        fontWeight: fontWeight,
        fontFamily: fontFamily ?? AppStringsKey.poppins,
        letterSpacing: letterspacing,
        decoration: textDecoration,
        decorationColor: decorationColor,
      );
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:provider/constants/app_colors.dart';
import 'package:provider/constants/app_strings.dart';
import 'package:resize/resize.dart';

class CustomDropdownField extends ConsumerWidget {
  final String? hint;
  final List<String> items;
  final String? value;
  final void Function(String?)? onChanged;
  final double? hintSize;
  final double? textSize;
  final FocusNode? focusNode;
  final InputBorder? inputBorder;
  final Color fillColor;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Widget? prefix;
  final Widget? suffix;
  final BoxConstraints? prefixIconConstraints;
  final BoxConstraints? suffixIconConstraints;
  final EdgeInsets? contentPadding;
  final AutovalidateMode? autoValidateMode;
  final String? Function(String?)? validator;

  const CustomDropdownField({
    Key? key,
    required this.items,
    this.value,
    this.hint,
    this.onChanged,
    this.hintSize,
    this.textSize,
    this.focusNode,
    this.inputBorder,
    this.fillColor = AppColors.backgroundGrey,
    this.prefixIcon,
    this.suffixIcon,
    this.prefix,
    this.suffix,
    this.prefixIconConstraints,
    this.suffixIconConstraints,
    this.contentPadding,
    this.autoValidateMode,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      icon: const Icon(Icons.keyboard_arrow_down),
      onChanged: onChanged,
      validator: validator,
      autovalidateMode: autoValidateMode,
      focusNode: focusNode,
      decoration: InputDecoration(
        filled: true,
        fillColor: fillColor,
        hintText: hint,
        counterText: '',
        labelStyle: TextStyle(
          color: AppColors.hintColor,
          fontWeight: FontWeight.w300,
          fontSize: hintSize ?? 12.sp,
          fontFamily: AppStringsKey.poppins,
        ),
        hintStyle: TextStyle(
          color: AppColors.hintColor,
          fontWeight: FontWeight.w300,
          fontSize: hintSize ?? 12.sp,
          fontFamily: AppStringsKey.poppins,
        ),
        border: inputBorder ?? _getBorder(),
        focusedBorder: inputBorder ?? _getEnabledBorder(),
        enabledBorder: inputBorder ?? _getBorder(),
        prefixIcon: prefixIcon,
        prefixIconConstraints: prefixIconConstraints,
        suffixIcon: suffixIcon,
        suffixIconConstraints: suffixIconConstraints,
        prefix: prefix,
        suffix: suffix,
        contentPadding:
            contentPadding ??
            EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      ),
      style: TextStyle(
        color: AppColors.black,
        fontWeight: FontWeight.w400,
        fontSize: textSize ?? 12.sp,
        fontFamily: AppStringsKey.poppins,
      ),
      items:
          items
              .map(
                (e) => DropdownMenuItem<String>(
                  value: e,
                  child: Text(
                    e,
                    style: TextStyle(
                      fontSize: textSize ?? 12.sp,
                      fontFamily: AppStringsKey.poppins,
                    ),
                  ),
                ),
              )
              .toList(),
    );
  }
}

OutlineInputBorder _getBorder() {
  return OutlineInputBorder(
    borderSide: BorderSide(color: AppColors.greyBorder, width: 1.w),
    borderRadius: BorderRadius.circular(5.r),
  );
}

UnderlineInputBorder underLineBorder() {
  return UnderlineInputBorder(
    borderSide: BorderSide(color: AppColors.tabDividerGrey, width: 1.w),
  );
}

OutlineInputBorder _getEnabledBorder() {
  return OutlineInputBorder(
    borderSide: BorderSide(color: AppColors.greyBorder, width: 1.w),
    borderRadius: BorderRadius.circular(5.r),
  );
}

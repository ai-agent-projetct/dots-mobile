import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resize/resize.dart';
import 'package:user/constants/app_colors.dart';
import 'package:user/constants/app_images.dart';
import 'package:user/constants/app_strings.dart';

// ignore: must_be_immutable
class PrimaryTextField extends ConsumerWidget {
  PrimaryTextField(
    this.controller, {
    this.hint,
    this.focusNode,
    this.inputBorder,
    this.hintSize,
    this.textSize,
    this.contentPadding,
    this.fillColor = AppColors.backgroundGrey,
    this.prefixIcon,
    this.prefix,
    this.suffixIcon,
    this.suffix,
    this.prefixIconConstraints,
    this.suffixIconConstraints,
    this.type = TextInputType.text,
    this.inputFormatter,
    this.textInputAction,
    this.onChanged,
    this.obscureText = false,
    this.validator,
    this.onTap,
    this.maxLines,
    this.minline,
    this.maxLength,
    this.readOnly = false,
    this.autoValidateMode,
    this.onFieldSubmitted,
    super.key,
  });

  final String? hint;
  final TextEditingController? controller;
  final TextInputType type;
  final List<TextInputFormatter>? inputFormatter;
  final TextInputAction? textInputAction;
  final double? hintSize;
  final double? textSize;
  final FocusNode? focusNode;
  final InputBorder? inputBorder;
  final Color fillColor;
  final Widget? prefixIcon;
  final Widget? prefix;
  final Widget? suffixIcon;
  final Widget? suffix;
  final BoxConstraints? prefixIconConstraints;
  final BoxConstraints? suffixIconConstraints;
  final EdgeInsets? contentPadding;
  final bool obscureText;
  final bool readOnly;
  final void Function()? onTap;
  final int? maxLines;
  final int? minline;
  final int? maxLength;
  String? Function(String?)? validator;
  final AutovalidateMode? autoValidateMode;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextFormField(
      minLines: minline,
      focusNode: focusNode,
      obscureText: obscureText,
      readOnly: readOnly,
      maxLines: maxLines,
      maxLength: maxLength,
      autovalidateMode: autoValidateMode,
      onFieldSubmitted: onFieldSubmitted,
      style: TextStyle(
        color: AppColors.black,
        fontWeight: FontWeight.w400,
        fontFamily: AppStringsKey.poppins,
        fontSize: textSize ?? 12.sp,
      ),
      controller: controller,
      cursorColor: AppColors.primary,
      onTap: onTap,
      keyboardType: type,
      inputFormatters: inputFormatter,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        filled: true,
        fillColor: fillColor,
        //labelText: hint,
        hintText: hint,
        counterText: '',
        labelStyle: TextStyle(
          color: AppColors.hintColor,
          fontWeight: FontWeight.w300,
          fontSize: hintSize ?? 12.sp,
        ),
        border: inputBorder ?? getBorder(),
        focusedBorder: inputBorder ?? getEnabledBorder(),
        enabledBorder: inputBorder ?? getBorder(),
        prefix: prefix,
        prefixIcon: prefixIcon,
        prefixIconConstraints: prefixIconConstraints,
        suffixIconConstraints: suffixIconConstraints,
        suffixIcon: suffixIcon,
        suffix: suffix,
        contentPadding:
            contentPadding ??
            EdgeInsets.only(left: 10.w, bottom: 5.h, top: 5.h, right: 10.w),
      ),
      onChanged: onChanged,
      validator: validator,
    );
  }
}

OutlineInputBorder getBorder() {
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

// ignore: must_be_immutable
class PasswordTextField extends ConsumerWidget {
  final String? hint;
  final TextEditingController? controller;
  final TextInputType type;
  final List<TextInputFormatter>? inputFormatter;
  final double? width;
  final double? height;
  final double? hintSize;
  final double? textSize;
  final FocusNode? focusNode;
  final Color fillColor;
  final bool enableborder;
  final InputBorder? focusedBorder;
  final AutovalidateMode? autoValidateMode;
  final EdgeInsets? contentPadding;
  String? Function(String?)? validator;
  final void Function()? changeVisibility;
  bool obscureText;
  final void Function(String)? onChanged;

  PasswordTextField(
    this.controller, {
    this.hint,
    this.width,
    this.height,
    this.focusNode,
    this.fillColor = AppColors.backgroundGrey,
    this.enableborder = true,
    this.focusedBorder,
    this.hintSize,
    this.textSize,
    this.autoValidateMode,
    this.contentPadding,
    this.type = TextInputType.text,
    this.inputFormatter,
    this.onChanged,
    this.changeVisibility,
    this.obscureText = true,
    this.validator,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StatefulBuilder(
      builder: (context, setState) {
        return SizedBox(
          height: height,
          width: width,
          child: TextFormField(
            focusNode: focusNode,
            obscureText: obscureText,
            style: TextStyle(
              color: AppColors.black,
              fontWeight: FontWeight.w400,
              fontSize: textSize ?? 12.sp,
            ),
            controller: controller,
            cursorColor: AppColors.primary,
            autovalidateMode: autoValidateMode,
            keyboardType: type,
            inputFormatters: inputFormatter,
            decoration: InputDecoration(
              filled: true,
              fillColor: fillColor,
              //  labelText: hint,
              hintText: hint,

              labelStyle: TextStyle(
                color: AppColors.hintColor,
                fontWeight: FontWeight.w300,
                fontSize: hintSize ?? 12.sp,
              ),
              border: enableborder ? getBorder() : null,
              focusedBorder: enableborder ? getEnabledBorder() : focusedBorder,
              enabledBorder: enableborder ? getBorder() : null,
              contentPadding:
                  contentPadding ??
                  EdgeInsets.only(
                    left: 10.w,
                    bottom: 5.h,
                    top: 5.h,
                    right: 10.w,
                  ),
              suffixIcon: Padding(
                padding: EdgeInsets.only(right: 10.0.w),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      obscureText = !obscureText;
                    });
                  },
                  child: Image.asset(
                    !obscureText
                        ? AppImages.viewPassword
                        : AppImages.hidePassword,
                  ),
                ),
              ),
              suffixIconConstraints: BoxConstraints(
                maxHeight: 20.h,
                maxWidth: 30.w,
              ),
            ),
            onChanged: onChanged,
            validator: validator,
          ),
        );
      },
    );
  }
}

OutlineInputBorder getEnabledBorder() {
  return OutlineInputBorder(
    borderSide: BorderSide(color: AppColors.greyBorder, width: 1.w),
    borderRadius: BorderRadius.circular(5.r),
  );
}

InputDecoration dropDownFieldInputDecoration(
  String hint, [
  double? hintSize,
  EdgeInsetsGeometry? contentPadding,
]) => InputDecoration(
  // filled: true,
  // fillColor: AppColors.white,
  hintText: hint,
  hintStyle: TextStyle(
    color: AppColors.hintColor,
    fontWeight: FontWeight.w300,
    fontSize: hintSize ?? 12.sp,
  ),
  border: getBorder(),
  focusedBorder: getEnabledBorder(),
  enabledBorder: getBorder(),
  contentPadding:
      contentPadding ??
      EdgeInsets.only(left: 10.w, bottom: 5.h, top: 5.h, right: 10.w),
);

class NoLeadingSpaceFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // If the new text starts with space, remove leading spaces
    if (newValue.text.startsWith(' ')) {
      return TextEditingValue(
        text: newValue.text.trimLeft(),
        selection: TextSelection.collapsed(
          offset: newValue.text.trimLeft().length,
        ),
      );
    }
    return newValue;
  }
}

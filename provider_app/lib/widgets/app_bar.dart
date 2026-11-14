import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/constants/app_colors.dart';
import 'package:provider/constants/app_images.dart';
import 'package:provider/widgets/app_text.dart';
import 'package:resize/resize.dart';

// ignore: must_be_immutable
class CustomAppBar extends ConsumerWidget {
  CustomAppBar({
    this.title,
    this.textSize,
    this.fontWeight = FontWeight.w600,
    this.appbarHeight = 50,
    this.leadingIcon = AppImages.backArrowBlack,
    this.titleColor = AppColors.secondary,
    this.showLeadingIcon = false,
    this.leadingIconColor,
    this.leadingIconHeight = 22.5,
    this.leadingIconEnabled = true,
    this.options,
    this.onTap,
    this.showAction = false,
    this.actionIcon,
    this.actionText,
    this.actionTextStyle,
    this.onActionTap,
    this.underlineActionText = false,
    super.key,
  });

  final String? title;
  Color titleColor;
  final double? textSize;
  final FontWeight? fontWeight;

  double appbarHeight;
  String leadingIcon;
  double? leadingIconHeight;
  bool showLeadingIcon;
  bool leadingIconEnabled;
  final void Function()? onTap;
  Color? leadingIconColor;

  Widget? options;

  final bool showAction;
  final Widget? actionIcon;
  final String? actionText;
  final TextStyle? actionTextStyle;
  final VoidCallback? onActionTap;

  final bool underlineActionText;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: appbarHeight,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (showLeadingIcon)
            InkWell(
              onTap: leadingIconEnabled ? onTap : null,
              child: Image.asset(
                leadingIcon,
                height: leadingIconHeight,
                color: leadingIconColor,
              ),
            ),

          if (title != null)
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: showLeadingIcon ? 15.w : 0),
                child: AppText(
                  title!,
                  textColor: titleColor,
                  fontWeight: fontWeight,
                  textSize: textSize,
                ),
              ),
            ),
          if (title == null) Spacer(),

          if (options != null) options!,

          if (showAction)
            if (showAction)
              InkWell(
                onTap: onActionTap,
                child: Padding(
                  padding: EdgeInsets.only(left: 10.w),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (actionText != null)
                        Text(
                          actionText!,
                          style:
                              actionTextStyle ??
                              TextStyle(
                                color: AppColors.primary,
                                fontSize: 16.sp,
                                decoration:
                                    underlineActionText == true
                                        ? TextDecoration.underline
                                        : TextDecoration.none,
                                decorationColor: AppColors.primary,
                              ),
                        ),

                      if (actionIcon != null) ...[
                        SizedBox(width: 4.w),
                        actionIcon!,
                      ],
                    ],
                  ),
                ),
              ),
        ],
      ),
    );
  }
}

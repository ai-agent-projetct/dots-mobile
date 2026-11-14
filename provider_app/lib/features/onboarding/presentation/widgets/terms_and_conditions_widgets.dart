import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/constants/app_colors.dart';
import 'package:provider/constants/app_strings.dart';
import 'package:provider/widgets/app_text.dart';
import 'package:resize/resize.dart';

class TermsAndConditionsWidget extends ConsumerWidget {
  const TermsAndConditionsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      child: AppText(
        translate(AppStringsKey.termsOfService),
        textSize: 12.sp,
        textColor: AppColors.hyperLinkColor,
      ),
    );
  }
}

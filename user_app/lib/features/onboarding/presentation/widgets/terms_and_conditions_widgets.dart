import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:resize/resize.dart';
import 'package:user/constants/app_colors.dart';
import 'package:user/constants/app_strings.dart';
import 'package:user/di/di.dart';
import 'package:user/widgets/app_text.dart';

class TermsAndConditionsWidget extends ConsumerWidget {
  const TermsAndConditionsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(onBoardingProvider);
    return InkWell(
      // onTap: () {
      //   debugPrint('kskskks');
      //   Navigator.pushNamed(
      //     context,
      //     AppRoutes.webView,
      //     arguments: {
      //       'title': translate(AppStringsKey.termsOfService),
      //       'url': Prefs().getConfigModel().data?.termsAndConditions.toString(),

      //       //'url': "https://betprivacypolicy.s3.ap-south-1.amazonaws.com/privacypolicy.html",
      //     },
      //   );
      // },
      child: AppText(
        translate(AppStringsKey.termsOfService),
        textSize: 12.sp,
        textColor: AppColors.hyperLinkColor,
      ),
    );
  }
}

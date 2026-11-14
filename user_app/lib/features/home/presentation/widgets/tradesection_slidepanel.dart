import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:resize/resize.dart';
import 'package:user/constants/app_colors.dart';
import 'package:user/constants/app_strings.dart';
import 'package:user/di/di.dart';
import 'package:user/features/home/presentation/widgets/trade&offer_card.dart';
import 'package:user/utils/helpers/common_utils.dart' show CommonUtils;
import 'package:user/widgets/app_text.dart';
import 'package:user/widgets/loading_widget.dart';

class TradeSection extends ConsumerWidget {
  const TradeSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alltrade = ref.watch(tradeProvider);
    final homeprovider = ref.watch(homeProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(
              translate(AppStringsKey.trade),
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
              ),
            ),
            TextButton(
              onPressed: () {
                CommonUtils.hideKeyBoard(context);
                homeprovider.onItemTap(3);
              },
              child: const Text(
                "See All",
                style: TextStyle(color: AppColors.red),
              ),
            ),
          ],
        ),
        if (alltrade.isLoading && alltrade.allTrades.isEmpty)
          const LoadingWidget()
        else if (alltrade.errorMessage != null)
          Center(
            child: Text(
              'Something went wrong.',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.red,
              ),
            ),
          )
        else if (alltrade.allTrades.isEmpty)
          Center(
            child: Text(
              "No trades found",
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          )
        else
          SizedBox(
            height: 180.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: alltrade.allTrades.length,
              itemBuilder: (context, index) {
                final item = alltrade.allTrades[index];
                return TradeCard(item: item);
              },
            ),
          ),
      ],
    );
  }
}

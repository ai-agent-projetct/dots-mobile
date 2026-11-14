import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:resize/resize.dart';
import 'package:user/constants/app_colors.dart';
import 'package:user/constants/app_strings.dart';
import 'package:user/di/di.dart';
import 'package:user/features/home/presentation/widgets/trade&offer_card.dart';
import 'package:user/widgets/app_text.dart';
import 'package:user/widgets/loading_widget.dart';

class OffersSection extends ConsumerWidget {
  const OffersSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mOffersProvider = ref.watch(homeProvider);

    // Flatten the map values into one list
    final allOffers = mOffersProvider.offers.values.expand((e) => e).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: AppText(
                translate(AppStringsKey.offersNearYou),
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
            ),
            TextButton(
              onPressed: () => ref.read(homeProvider).onItemTap(1),
              child: const Text("See All", style: TextStyle(color: Colors.red)),
            ),
          ],
        ),

        if (mOffersProvider.isLoading && mOffersProvider.offers.isEmpty)
          Center(child: LoadingWidget())
        else if (mOffersProvider.error != null)
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
        else if (mOffersProvider.offers.isEmpty)
          Center(
            child: Text(
              "No offers available",
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
              itemCount: allOffers.length,
              itemBuilder: (context, index) {
                return OfferCard(item: allOffers[index]);
              },
            ),
          ),
      ],
    );
  }
}

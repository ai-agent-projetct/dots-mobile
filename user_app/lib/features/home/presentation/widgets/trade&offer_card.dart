import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:resize/resize.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user/constants/app_colors.dart';
import 'package:user/features/home/data/models/trade_model.dart';
import 'package:user/widgets/app_text.dart';

class TradeCard extends StatelessWidget {
  final TradeData item;
  const TradeCard({required this.item, super.key});

  String getDate(String? dateTime) {
    if (dateTime == null || dateTime.isEmpty) return '';
    return dateTime.split(" ").first;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160.w,
      margin: EdgeInsets.only(right: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10.r)),
            child:
                item.uploadImage?.isNotEmpty == true
                    ? Image.network(
                      item.uploadImage!,
                      height: 100.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.white,
                          child: Container(
                            height: 100.h,
                            width: double.infinity,
                            color: Colors.white,
                          ),
                        );
                      },
                      errorBuilder:
                          (context, error, stackTrace) => _buildNoImageWidget(),
                    )
                    : _buildNoImageWidget(),
          ),

          Expanded(
            child: Padding(
              padding: EdgeInsets.all(8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    item.userName!,
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 11.sp,
                    ),
                    // maxLines: 1,
                    // overflow: TextOverflow.ellipsis,
                  ),
                  AppText(
                    DateFormat('d MMM y').format(
                      item.createdAt != null
                          ? DateTime.tryParse(item.createdAt!) ?? DateTime.now()
                          : DateTime.now(),
                    ),
                    textColor: Colors.grey,
                    textSize: 11.sp,
                  ),
                  SizedBox(height: 4.h),
                  Expanded(
                    child: SingleChildScrollView(
                      child: AppText(
                        item.description ?? "No description",
                        textAlign: TextAlign.justify,
                        textSize: 10.sp,
                        //maxLines: 2,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OfferCard extends ConsumerWidget {
  final dynamic item;
  const OfferCard({required this.item, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: 160.w,
      margin: EdgeInsets.only(right: 12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(color: AppColors.backGroundGrey, offset: Offset(0, 2)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.r),
        child: Stack(
          children: [
            Image.network(
              item.uploadImage, // API image field

              height: 180.h,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) => _buildNoImageWidget(),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.white,
                  child: Container(
                    width: double.infinity,
                    height: 200.h,
                    color: Colors.white,
                  ),
                );
              },
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 10.h,
              left: 10.w,
              right: 10.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "${item.discount.replaceAll(RegExp(r'\.0+$'), '')}%",
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 2.h),

                  Text(
                    item.description,
                    style: TextStyle(fontSize: 10.sp, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildNoImageWidget() {
  return Container(
    height: 100.h,
    width: double.infinity,
    color: Colors.grey.shade200,
    alignment: Alignment.center,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.broken_image, color: Colors.grey, size: 30),
        SizedBox(height: 4),
        Text(
          "Unavailable",
          style: TextStyle(color: Colors.grey, fontSize: 11.sp),
        ),
      ],
    ),
  );
}

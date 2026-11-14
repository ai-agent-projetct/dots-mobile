import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:resize/resize.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user/constants/app_colors.dart';
import 'package:user/constants/app_strings.dart';
import 'package:user/di/di.dart';
import 'package:user/utils/helpers/common_utils.dart';
import 'package:user/widgets/app_text.dart';
import 'package:user/widgets/common_widgets.dart';
import 'package:user/widgets/loading_widget.dart';

class TrendsSection extends ConsumerWidget {
  const TrendsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mtrendsprovider = ref.watch(trendsProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(
              translate(AppStringsKey.trendsText),
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
              ),
            ),
            TextButton(
              onPressed: () {
                CommonUtils.hideKeyBoard(context);
                ref.read(homeProvider).onItemTap(2);
              },
              child: Text("See All", style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
        if (mtrendsprovider.isLoading && mtrendsprovider.trends.isEmpty)
          const LoadingWidget()
        else if (mtrendsprovider.error != null)
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
        else if (mtrendsprovider.trends.isEmpty)
          Center(
            child: Text(
              "No trends available.",
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
              itemCount: mtrendsprovider.trends.length,
              itemBuilder: (context, index) {
                final item = mtrendsprovider.trends[index];
                return Container(
                  width: 160.w,
                  margin: EdgeInsets.only(right: 12.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: Image.network(
                      item.mediaFile,
                      height: 180.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) => buildNoImageWidget(),
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
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}

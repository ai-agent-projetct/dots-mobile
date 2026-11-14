import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resize/resize.dart';
import 'package:user/constants/app_images.dart';
import 'package:user/features/serviceProvider/data/models/rating_response_model.dart';
import 'package:user/widgets/app_text.dart';
import 'package:user/widgets/profilecircular.dart';

class ReviewDetails extends ConsumerWidget {
  final UserReview review;

  const ReviewDetails({super.key, required this.review});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileCircleAvatar(imageUrl: review.profileImg ?? '', radius: 15.r),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                review.userName,
                textSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(height: 5.h),
              AppText(
                review.reviews,
                textSize: 12.5.sp,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
        ),
      ],
    );
  }
}



// class ReviewDetails extends ConsumerWidget {
//   final int index;

//   const ReviewDetails({super.key, required this.index});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Row(
//       key: key,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               height: 40.h,
//               width: 40.w,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//               ),
//               child: 
//               CircleAvatar(
//                 backgroundImage: AssetImage(AppImages.trade),
//               ),
//             ),
//           ],
//         ),
//         Expanded(
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 AppText(
//                   'Joel Smith',
//                   textSize: 14.sp,
//                   fontWeight: FontWeight.w500,
//                 ),
//                 SizedBox(
//                   height: 5.h,
//                 ),
//                 AppText(
//                   'He is actually good and professional, \nhe also has good customer service \nskill.',
//                   textSize: 12.5.sp,
//                   maxLines: 4,
//                   textAlign: TextAlign.left,
//                   overflow: TextOverflow.visible,
//                   fontWeight: FontWeight.w400,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:universal_io/io.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resize/resize.dart';
import 'package:user/constants/app_colors.dart';
import 'package:user/constants/app_images.dart';
import 'package:user/constants/app_strings.dart';
import 'package:user/widgets/app_text.dart';
import 'package:user/widgets/bottomsheet_scaffold.dart';

// ignore: must_be_immutable
class ImagePickerWidget extends ConsumerWidget {
  ImagePickerWidget({required this.data, super.key});
  Function(File) data;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BottomSheetScaffold(
        child: Column(
      children: [
        InkWell(
            onTap: () => Navigator.pop(context),
            child: Align(
              alignment: Alignment.centerRight,
              child: Image.asset(
                AppImages.closeIconPath,
                width: 15.w,
                height: 15.h,
              ),
            )),
        SizedBox(
          height: 20.h,
        ),
        InkWell(
          onTap: () {
            _pickAnImage(ref, context);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            decoration: BoxDecoration(
                border: Border.all(color: AppColors.greyDivider, width: 0.5.w),
                borderRadius: BorderRadius.circular(10.r)),
            child: Row(
              children: [
                Image.asset(
                  AppImages.uploadImg,
                  width: 15.w,
                  height: 15.h,
                ),
                SizedBox(
                  width: 5.w,
                ),
                Expanded(
                  child: AppText(
                    translate(AppStringsKey.gallery),
                    fontWeight: FontWeight.w600,
                    textColor: AppColors.secondary,
                  ),
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
        InkWell(
          onTap: () {
            _captureFromCamera(ref, context);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            decoration: BoxDecoration(
                border: Border.all(color: AppColors.greyDivider, width: 0.5.w),
                borderRadius: BorderRadius.circular(10.r)),
            child: Row(
              children: [
                Image.asset(
                  AppImages.cameraImg,
                  width: 15.w,
                  height: 15.h,
                ),
                SizedBox(
                  width: 5.w,
                ),
                Expanded(
                  child: AppText(
                    translate(AppStringsKey.camera),
                    fontWeight: FontWeight.w600,
                    textColor: AppColors.secondary,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    ));
  }

  _pickAnImage(WidgetRef ref, BuildContext context) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      data(File(image.path));
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }

  _captureFromCamera(WidgetRef ref, BuildContext context) async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      data(File(photo.path.toString()));
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resize/resize.dart';
import 'package:user/constants/app_colors.dart';
import 'package:user/constants/app_images.dart';
import 'package:user/constants/app_strings.dart';
import 'package:user/di/di.dart';
import 'package:user/utils/helpers/common_utils.dart';
import 'package:user/widgets/app_text.dart';
import 'package:user/widgets/app_text_field.dart';
import 'package:user/widgets/common_widgets.dart';
import 'package:user/widgets/image_picker_widget.dart';
import 'package:user/widgets/loading_widget.dart';
import 'package:user/widgets/show_snackbar.dart';

class CreatePollDialog extends ConsumerWidget {
  const CreatePollDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var mPollProvider = ref.watch(pollProvider);
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        mPollProvider.clearControllers();
      },
      child: Dialog(
        backgroundColor: AppColors.white,
        insetPadding: EdgeInsets.symmetric(horizontal: 15.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0.r),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: 16.0.w,
            right: 16.w,
            top: 16.0.h,
            bottom: 16.0.h,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  "Create Poll",
                  textSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: 10.h),
                horizontalSeparatorWidget(),
                SizedBox(height: 10.h),
                AppText(
                  "Select Topic",
                  textSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: 10.h),
                LayoutBuilder(
                  builder: (context, constraints) {
                    return DropdownMenu<String>(
                      initialSelection:
                          mPollProvider.selectedTopicId.isEmpty
                              ? ""
                              : mPollProvider.selectedTopicId,
                      width: constraints.maxWidth,
                      textStyle: TextStyle(
                        color: AppColors.black,
                        fontWeight: FontWeight.w400,
                        fontFamily: AppStringsKey.poppins,
                        fontSize: 13.sp,
                      ),
                      menuStyle: MenuStyle(
                        backgroundColor: WidgetStatePropertyAll(
                          AppColors.white,
                        ),
                      ),
                      trailingIcon: Icon(Icons.keyboard_arrow_down),
                      inputDecorationTheme: InputDecorationTheme(
                        filled: true,
                        fillColor: AppColors.backGroundGrey,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.greyBorder,
                            width: 1.w,
                          ),
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.greyBorder,
                            width: 1.w,
                          ),
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.greyBorder,
                            width: 1.w,
                          ),
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                        contentPadding: EdgeInsets.only(
                          left: 10.w,
                          bottom: 5.h,
                          top: 5.h,
                          right: 10.w,
                        ),
                      ),
                      dropdownMenuEntries: [
                        const DropdownMenuEntry<String>(
                          value: "",
                          label: "Select",
                        ),
                        ...mPollProvider.topicsData.map((topic) {
                          return DropdownMenuEntry<String>(
                            value: topic.topicId,
                            label: topic.topic,
                          );
                        }),
                      ],
                      onSelected: (String? value) {
                        debugPrint(value);
                        if (value == "" || value == null) {
                          mPollProvider.setSelectedTopic("", "");
                        } else {
                          final selectedTopic = mPollProvider.topicsData
                              .firstWhere((topic) => topic.topicId == value);
                          mPollProvider.setSelectedTopic(
                            selectedTopic.topicId,
                            selectedTopic.topic,
                          );
                        }
                      },
                    );
                  },
                ),
                SizedBox(height: 10.h),
                AppText(
                  "Upload Image",
                  textSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: 10.h),
                SizedBox(
                  width: ResizeUtil().screenWidth,
                  child: Row(
                    children: [
                      mPollProvider.isLoading
                          ? LoadingWidget()
                          : mPollProvider.selectedImage.isNotEmpty
                          ? Container()
                          : ElevatedButton(
                            onPressed:
                                mPollProvider.selectedImageText.isEmpty
                                    ? () {
                                      showModalBottomSheet(
                                        context: context,
                                        enableDrag: false,
                                        backgroundColor: AppColors.transparent,
                                        builder:
                                            (context) => ImagePickerWidget(
                                              data: (file) {
                                                if (file.existsSync()) {
                                                  mPollProvider
                                                      .selectFromGallery(file);
                                                }
                                              },
                                            ),
                                      );
                                    }
                                    : () {
                                      if (mPollProvider.choosedImage != null) {
                                        mPollProvider.uploadFile(
                                          mPollProvider.choosedImage!,
                                        );
                                      } else {
                                        showSnackBar(
                                          message:
                                              "Please choose the image to upload",
                                        );
                                      }
                                    },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.backGroundGrey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.r),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.w,
                                vertical: 5.h,
                              ),
                            ),
                            child: AppText(
                              mPollProvider.selectedImageText.isEmpty
                                  ? 'Select'
                                  : 'Upload',
                              textSize: 12.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                      const SizedBox(width: 10),
                      mPollProvider.selectedImageText.isEmpty
                          ? Container()
                          : Expanded(
                            child: Row(
                              children: [
                                Flexible(
                                  child: AppText(
                                    mPollProvider.selectedImageText,
                                    maxLines: 2,
                                    softWrap: true,
                                    // overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    mPollProvider.clearImage();
                                  },
                                  icon: Icon(
                                    Icons.close,
                                    size: 18.sp,
                                    color: AppColors.primary,
                                  ),
                                  tooltip: 'Remove image',
                                ),
                              ],
                            ),
                          ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                AppText(
                  "Questions",
                  textSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
                PrimaryTextField(
                  mPollProvider.questionController,
                  hint: "Your Question",
                  fillColor: AppColors.white,
                  inputBorder: UnderlineInputBorder(),
                  contentPadding: EdgeInsets.zero,
                ),
                SizedBox(height: 20.h),
                AppText(
                  "Options",
                  textSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
                ...mPollProvider.optionControllers.asMap().entries.map((entry) {
                  final index = entry.key;
                  final controller = entry.value;
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.0.h),
                    child: PrimaryTextField(
                      controller,
                      hint: "Option 0${index + 1}",
                      fillColor: AppColors.white,
                      inputBorder: UnderlineInputBorder(),
                      contentPadding: EdgeInsets.zero,
                    ),
                  );
                }),
                if (mPollProvider.optionControllers.length < 4)
                  Center(
                    child: TextButton(
                      onPressed: () {
                        if (mPollProvider.optionControllers.length < 4) {
                          mPollProvider.addOption();
                        }
                      },
                      child: AppText(
                        "+ Add Line",
                        textColor: AppColors.primary,
                      ),
                    ),
                  ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText("Allow Multiple Answers"),
                    Switch(
                      value: mPollProvider.allowMultipleAnswers,
                      activeColor: AppColors.white,
                      activeTrackColor: AppColors.primary,
                      onChanged: (value) {
                        mPollProvider.toggleAllowMultipleAnswers(value);
                      },
                    ),
                  ],
                ),
                SizedBox(height: 15.h),
                Align(
                  alignment: Alignment.centerRight,
                  child:
                      mPollProvider.isLoading
                          ? LoadingWidget()
                          : FloatingActionButton(
                            heroTag: 'createpollFab',
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2.0.r),
                            ),
                            onPressed:
                                mPollProvider.isLoading
                                    ? null
                                    : () async {
                                      debugPrint('hi');
                                      if (mPollProvider
                                          .selectedTopics
                                          .isEmpty) {
                                        debugPrint('hi 1');
                                        CommonUtils.showToast(
                                          "Select the topic of the poll",
                                        );
                                      } else if (mPollProvider
                                              .selectedImageText
                                              .isNotEmpty &&
                                          mPollProvider.selectedImage.isEmpty) {
                                        CommonUtils.showToast(
                                          "Upload the selected image to post poll or remove images to post",
                                        );
                                      } else {
                                        var result =
                                            await mPollProvider.addPoll();
                                        if (result == true) {
                                          if (!context.mounted) return;
                                          Navigator.pop(context);
                                          showSnackBar(
                                            message:
                                                "Poll request submitted successfully",
                                            bgColor: AppColors.oliveGreen,
                                          );
                                        } else {
                                          CommonUtils.showToast(
                                            "Enter the questions and options to submit",
                                          );
                                        }
                                      }
                                    },
                            backgroundColor: AppColors.primary,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Image.asset(
                                AppImages.msgSend,
                                fit: BoxFit.cover,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

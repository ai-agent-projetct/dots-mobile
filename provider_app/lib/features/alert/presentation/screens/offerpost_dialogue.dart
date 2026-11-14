import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/constants/app_colors.dart';
import 'package:provider/constants/app_strings.dart';
import 'package:provider/di/di.dart';
import 'package:provider/features/alert/data/model/getalloffers_model.dart';
import 'package:provider/features/onboarding/presentation/provider/onboarding_provider.dart';
import 'package:provider/utils/helpers/common_utils.dart';
import 'package:provider/widgets/app_multiselectdropdown.dart';
import 'package:provider/widgets/app_text.dart';
import 'package:provider/widgets/app_text_field.dart';
import 'package:provider/widgets/common_widgets.dart';
import 'package:provider/widgets/datepicker.dart';
import 'package:resize/resize.dart';

class OfferpostDialogue extends ConsumerStatefulWidget {
  final OfferItem? offerItem;

  const OfferpostDialogue({super.key, this.offerItem});

  @override
  ConsumerState<OfferpostDialogue> createState() => _OfferpostDialogueState();
}

class _OfferpostDialogueState extends ConsumerState<OfferpostDialogue> {
  bool _isToastShown = false;
  final dateFormat = DateFormat("yyyy-MM-dd");

  @override
  void initState() {
    super.initState();
    final malertprovider = ref.read(alertProvider);
    final monboardingProvider = ref.read(onboardingProvider);

    if (widget.offerItem != null) {
      // Editing existing offer
      final dateFormat = DateFormat("dd/MM/yyyy");

      malertprovider.headingController.text = widget.offerItem!.title;
      malertprovider.descriptionController.text = widget.offerItem!.description;
      malertprovider.discountController.text = widget.offerItem!.discount;

      malertprovider.validFrom = dateFormat.parse(widget.offerItem!.startDate);
      malertprovider.validTo = dateFormat.parse(widget.offerItem!.expiryDate);

      monboardingProvider.selectedImage = widget.offerItem!.uploadImage;
      monboardingProvider.selectedImageText = widget.offerItem!.uploadImage;

      malertprovider.isActive = widget.offerItem!.isActive == 1;

      // Set category/subcategory ids for update
      malertprovider.categoryId = widget.offerItem!.categoryId;
      malertprovider.subCategoryId = widget.offerItem!.subCategoryId;
    } else {
      // Adding new offer - fetch categories
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(alertProvider).getProviderServices();
      });
      Future.microtask(() {
        ref.read(alertProvider).clearControllers();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final malertprovider = ref.watch(alertProvider);
    final monboardingProvider = ref.watch(onboardingProvider);

    return AlertDialog(
      backgroundColor: AppColors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: 10.w),
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0.r)),
      title: Row(
        children: [
          AppText(
            widget.offerItem != null ? "Edit Offer" : "Add Offer",
            textSize: 14.sp,
            fontFamily: AppStringsKey.poppins,
            fontWeight: FontWeight.bold,
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.clear_sharp),
            onPressed: () {
              Navigator.pop(context);
              malertprovider.clearControllers();
              monboardingProvider.clearImage();
            },
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: SizedBox(
          width: ResizeUtil().screenWidth,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              horizontalSeparatorWidget(),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Dropdown (Only for Add)
                    if (widget.offerItem == null)
                      SingleSelectDropdown(
                        title: 'Sub Category',
                        hintText: 'Select Sub Category',
                        items: malertprovider.subCategoryNames,
                        selectedItem: malertprovider.selectedSubCategory,
                        onSelectionChanged: (String? selectedItem) {
                          if (selectedItem == null) return;

                          setState(() {
                            malertprovider.selectedSubCategory = selectedItem;
                          });

                          final subCategory = malertprovider.subCategories
                              .firstWhere(
                                (sub) => sub.subCategoryName == selectedItem,
                              );

                          malertprovider.subCategoryId =
                              subCategory.subCategoryId;
                          malertprovider.categoryId = subCategory.categoryId;
                        },
                      ),

                    const SizedBox(height: 10),

                    // Heading
                    PrimaryTextField(
                      malertprovider.headingController,
                      hint: "Heading",
                      inputFormatter: [NoLeadingSpaceFormatter()],
                    ),
                    const SizedBox(height: 10),

                    // Description
                    PrimaryTextField(
                      malertprovider.descriptionController,
                      maxLines: null,
                      hint: "Description",
                      minline: 4,
                      maxLength: 255,
                      inputFormatter: [NoLeadingSpaceFormatter()],
                    ),
                    const SizedBox(height: 10),

                    // Discount
                    PrimaryTextField(
                      malertprovider.discountController,
                      hint: "Discount (%)",
                      type: TextInputType.number,
                      inputFormatter: [
                        FilteringTextInputFormatter.digitsOnly,
                        NoLeadingSpaceFormatter(),
                      ],
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          final discount = int.tryParse(value) ?? 0;
                          if (discount > 100) {
                            malertprovider.discountController.text = '100';
                            malertprovider
                                .discountController
                                .selection = TextSelection.fromPosition(
                              TextPosition(
                                offset:
                                    malertprovider
                                        .discountController
                                        .text
                                        .length,
                              ),
                            );

                            if (!_isToastShown) {
                              _isToastShown = true;
                              CommonUtils.showToast(
                                "Discount cannot be more than 100%",
                              );
                            }
                          } else {
                            _isToastShown = false;
                          }
                        } else {
                          _isToastShown = false;
                        }
                      },
                    ),
                    const SizedBox(height: 10),

                    // Date Pickers
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DatePickerField(
                          label: "Valid From",
                          selectedDate: malertprovider.validFrom,
                          onDateSelected: (date) {
                            setState(() {
                              malertprovider.validFrom = date;
                            });
                          },
                        ),
                        SizedBox(width: 20.w),
                        DatePickerField(
                          label: "Valid To",
                          selectedDate: malertprovider.validTo,
                          onDateSelected: (date) {
                            setState(() {
                              malertprovider.validTo = date;
                            });
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Upload Image
                    Align(
                      alignment: Alignment.centerLeft,
                      child: AppText(
                        "Upload Image",
                        textStyle: TextStyle(
                          fontFamily: AppStringsKey.poppins,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (monboardingProvider.selectedImageText.isEmpty)
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 25,
                                    vertical: 10,
                                  ),
                                  backgroundColor: AppColors.backgroundGrey,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    side: BorderSide(
                                      color: AppColors.greyBorder,
                                    ),
                                  ),

                                  textStyle: TextStyle(
                                    fontFamily: AppStringsKey.poppins,
                                    fontSize:
                                        12.sp, // match the font size you use elsewhere
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                onPressed: () {
                                  monboardingProvider.pickFromGallery();
                                },
                                child: AppText(
                                  'Select',
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    color: AppColors.black,
                                  ),
                                ),
                              )
                            else if (monboardingProvider
                                .selectedImage
                                .isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(right: 5.0),
                                child: AppText(
                                  'Uploaded',
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    color: Colors.green,
                                  ),
                                ),
                              )
                            else
                              Padding(
                                padding: const EdgeInsets.only(right: 5.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 25,
                                      vertical: 10,
                                    ),
                                    backgroundColor: AppColors.backgroundGrey,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      side: BorderSide(
                                        color: AppColors.greyBorder,
                                      ),
                                    ),

                                    textStyle: TextStyle(
                                      fontFamily: AppStringsKey.poppins,
                                      fontSize:
                                          12.sp, // match the font size you use elsewhere
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  onPressed: () {
                                    if (monboardingProvider.pikedImage !=
                                        null) {
                                      monboardingProvider.uploadFile(
                                        monboardingProvider.pikedImage!,
                                      );
                                    }
                                  },
                                  child: AppText(
                                    'Upload',
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      color: AppColors.black,
                                    ),
                                  ),
                                ),
                              ),

                            if (monboardingProvider
                                    .selectedImageText
                                    .isNotEmpty ||
                                monboardingProvider.selectedImage.isNotEmpty)
                              IconButton(
                                icon: Icon(Icons.clear),
                                onPressed: () {
                                  monboardingProvider.clearImage();
                                },
                              ),
                          ],
                        ),
                        Spacer(),
                        AppText(
                          malertprovider.isActive ? "Active" : "Inactive",
                          textSize: 12.sp,
                          fontFamily: AppStringsKey.poppins,
                        ),
                        Switch(
                          value: malertprovider.isActive,
                          onChanged: (val) {
                            setState(() {
                              malertprovider.isActive = val;
                            });
                          },
                          thumbColor: MaterialStateProperty.resolveWith<Color>((
                            states,
                          ) {
                            if (states.contains(MaterialState.selected)) {
                              return AppColors.white;
                            }
                            return AppColors.white;
                          }),
                          trackColor: MaterialStateProperty.resolveWith<Color>((
                            states,
                          ) {
                            if (states.contains(MaterialState.selected)) {
                              return AppColors.primary;
                            }
                            return Colors.grey;
                          }),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Save Button
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            // vertical: 10,
                          ),

                          backgroundColor: AppColors.primary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: BorderSide(color: AppColors.greyBorder),
                          ),
                          foregroundColor: AppColors.white,
                        ),
                        onPressed:
                            malertprovider.isLoading
                                ? null
                                : () async {
                                  if (malertprovider.validateForm(context)) {
                                    if (widget.offerItem != null) {
                                      if (monboardingProvider
                                              .selectedImage
                                              .isEmpty &&
                                          widget
                                              .offerItem!
                                              .uploadImage
                                              .isEmpty) {
                                        CommonUtils.showToast(
                                          "Please upload an image",
                                        );
                                        return;
                                      }
                                      if (monboardingProvider
                                          .selectedImage
                                          .isEmpty) {
                                        CommonUtils.showToast(
                                          "Please upload a new image before updating",
                                        );
                                        return;
                                      }
                                      final body = {
                                        "title":
                                            malertprovider
                                                .headingController
                                                .text
                                                .trim(),
                                        "description":
                                            malertprovider
                                                .descriptionController
                                                .text
                                                .trim(),
                                        "is_active":
                                            malertprovider.isActive ? 1 : 0,
                                        "discount":
                                            malertprovider
                                                .discountController
                                                .text
                                                .trim(),
                                        "upload_image":
                                            monboardingProvider
                                                    .selectedImage
                                                    .isNotEmpty
                                                ? monboardingProvider
                                                    .selectedImage
                                                : widget.offerItem!.uploadImage,
                                        "start_date": dateFormat.format(
                                          malertprovider.validFrom!,
                                        ),
                                        "expiry_date": dateFormat.format(
                                          malertprovider.validTo!,
                                        ),
                                      };

                                      final success = await malertprovider
                                          .updateOffer(
                                            context,
                                            widget.offerItem!.offerId,
                                            body,
                                          );
                                      if (success && context.mounted) {
                                        Navigator.pop(context, true);
                                      }
                                    } else {
                                      if (malertprovider.subCategoryId ==
                                              null ||
                                          malertprovider.selectedSubCategory ==
                                              null) {
                                        CommonUtils.showToast(
                                          "Please select a Sub Category",
                                        );
                                        return;
                                      }

                                      if (monboardingProvider
                                          .selectedImage
                                          .isEmpty) {
                                        CommonUtils.showToast(
                                          "Please select and upload an image",
                                        );
                                        return;
                                      }

                                      final body = {
                                        "category_id":
                                            malertprovider.categoryId,
                                        "sub_category_id":
                                            malertprovider.subCategoryId,
                                        "title":
                                            malertprovider
                                                .headingController
                                                .text
                                                .trim(),
                                        "description":
                                            malertprovider
                                                .descriptionController
                                                .text
                                                .trim(),
                                        "discount":
                                            malertprovider
                                                .discountController
                                                .text
                                                .trim(),
                                        "start_date": dateFormat.format(
                                          malertprovider.validFrom!,
                                        ),
                                        "expiry_date": dateFormat.format(
                                          malertprovider.validTo!,
                                        ),
                                        "upload_image":
                                            monboardingProvider.selectedImage,
                                        "is_active":
                                            malertprovider.isActive ? 1 : 0,
                                      };

                                      final success = await malertprovider
                                          .createOffer(body);

                                      if (success && context.mounted) {
                                        Navigator.pop(context, true);
                                      }
                                    }
                                  }
                                },
                        child:
                            malertprovider.isLoading
                                ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: LoadingIndicator(
                                    indicatorType: Indicator.ballPulse,
                                    colors: [AppColors.white],
                                    strokeWidth: 2,
                                    backgroundColor: Colors.transparent,
                                  ),
                                )
                                : AppText(
                                  widget.offerItem != null ? 'Save' : 'Add',
                                  textStyle: TextStyle(
                                    fontFamily: AppStringsKey.poppins,
                                    fontSize: 14.sp,
                                    color: AppColors.white,
                                  ),
                                ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

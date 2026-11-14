import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/constants/app_colors.dart';
import 'package:provider/constants/app_strings.dart';
import 'package:provider/di/di.dart';
import 'package:provider/utils/helpers/common_utils.dart';
import 'package:provider/widgets/app_button.dart';
import 'package:provider/widgets/app_multiselectdropdown.dart';
import 'package:provider/widgets/app_text.dart';
import 'package:provider/widgets/common_widgets.dart';
import 'package:resize/resize.dart';

class AddServiceDialog extends ConsumerStatefulWidget {
  const AddServiceDialog({super.key});

  @override
  AddServiceDialogState createState() => AddServiceDialogState();
}

class AddServiceDialogState extends ConsumerState<AddServiceDialog> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(onboardingProvider).getCategory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final monboardingProvider = ref.watch(onboardingProvider);
    final mcategoryProvider = ref.watch(categoryProvider);

    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 10.w),
      backgroundColor: Colors.white,
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5.0.r)),
      ),
      actionsPadding: EdgeInsets.only(bottom: 15.h, right: 15.w, left: 15.w),
      actionsAlignment: MainAxisAlignment.end,
      titlePadding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),

      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText(
            'Add Service',
            textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.sp),
          ),

          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            alignment: Alignment.centerRight,
            icon: const Icon(Icons.close),
            padding: EdgeInsets.zero,
            visualDensity: const VisualDensity(
              horizontal: -4.0,
              vertical: -4.0,
            ),
          ),
        ],
      ),

      content: SizedBox(
        width: ResizeUtil().screenWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            horizontalSeparatorWidget(),

            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  SingleSelectDropdown(
                    title: 'Select Category',
                    hintText: 'Select Category',
                    items: monboardingProvider.categoryNames,
                    selectedItem: monboardingProvider.selectedCategory,
                    onSelectionChanged: (String? selectedItem) async {
                      if (monboardingProvider.selectedCategory ==
                          selectedItem) {
                        print('Same category selected, skipping API call.');
                        return;
                      }

                      setState(() {
                        monboardingProvider.selectedCategory = selectedItem!;
                      });

                      final category = monboardingProvider.categories
                          .firstWhere(
                            (cat) => cat.categoryName == selectedItem,
                          );

                      final categoryId = category.categoryId;
                      print('Selected Category ID: $categoryId');

                      if (categoryId.isNotEmpty) {
                        await monboardingProvider.getSubCategory(categoryId);
                        setState(() {});
                      }
                    },
                  ),
                  SizedBox(height: 15.h),
                  if (monboardingProvider.subCategoryNames.isNotEmpty)
                    Visibility(
                      visible: monboardingProvider.subCategoryNames.isNotEmpty,
                      child: MultiSelectDropdown(
                        title: 'Sub Category',
                        hintText: 'Sub Category',
                        items: monboardingProvider.subCategoryNames,
                        selectedItems:
                            monboardingProvider.selectedSubCategories,

                        onSelectionChanged: (List<String> selectedItems) {
                          setState(() {
                            monboardingProvider.selectedSubCategories =
                                selectedItems;

                            // 🔹 Print selected names
                            print("Selected Sub Categories: $selectedItems");

                            mcategoryProvider.subCatIds =
                                monboardingProvider.subCategories
                                    .where(
                                      (subCat) => selectedItems.contains(
                                        subCat.subCategoryName,
                                      ),
                                    )
                                    .map((subCat) => subCat.subCategoryId)
                                    .toList();
                            print(
                              'efdsf${mcategoryProvider.subCatIds.toString()}',
                            );
                          });
                        },
                      ),
                    ),
                  SizedBox(height: 15.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: EdgeInsets.symmetric(
                          horizontal: 30.w,
                          // vertical: 5.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                      ),
                      onPressed:
                          mcategoryProvider.isLoading
                              ? null
                              : () async {
                                if (monboardingProvider.selectedCategory ==
                                    null) {
                                  return CommonUtils.showToast(
                                    "Select category",
                                  );
                                }
                                if (mcategoryProvider.subCatIds.isEmpty) {
                                  return CommonUtils.showToast(
                                    "Select subcategory",
                                  );
                                }

                                /// API call
                                await mcategoryProvider.updateService();

                                /// Clear after success
                                monboardingProvider.selectedCategory = null;
                                monboardingProvider.selectedSubCategories
                                    .clear();
                                mcategoryProvider.subCatIds.clear();

                                Navigator.pop(context);
                              },
                      child:
                          mcategoryProvider.isLoading
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
                                "Add",
                                textStyle: TextStyle(
                                  color: AppColors.white,
                                  fontFamily: AppStringsKey.poppins,
                                  fontSize: 16.sp,
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
    );
  }
}

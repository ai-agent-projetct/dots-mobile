import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/constants/app_colors.dart';
import 'package:provider/constants/app_strings.dart';
import 'package:provider/widgets/app_text.dart';
import 'package:resize/resize.dart';

class DatePickerField extends ConsumerWidget {
  final String label;
  final DateTime? selectedDate;
  final Function(DateTime) onDateSelected;

  const DatePickerField({
    Key? key,
    required this.label,
    required this.selectedDate,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            label,
            fontFamily: AppStringsKey.poppins,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(height: 4.h),
          GestureDetector(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: selectedDate ?? DateTime.now(),
                firstDate:
                    selectedDate != null &&
                            selectedDate!.isBefore(DateTime.now())
                        ? selectedDate! // allow past date when editing
                        : DateTime.now(),
                lastDate: DateTime(2030),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                        primary: AppColors.primary,
                        onPrimary: Colors.white,
                        onSurface: Colors.black,
                      ),
                      textButtonTheme: TextButtonThemeData(
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.primary,
                        ),
                      ),
                    ),
                    child: child!,
                  );
                },
              );

              if (picked != null) {
                onDateSelected(picked);
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.backgroundGrey, // Background color grey
                border: Border.all(color: AppColors.greyBorder),
                borderRadius: BorderRadius.circular(5),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 18,
                    color: AppColors.hintColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    selectedDate != null
                        ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
                        : "Select Date",
                    style: TextStyle(
                      color:
                          selectedDate != null
                              ? Colors.black
                              : AppColors.hintColor,
                      fontFamily: AppStringsKey.poppins,
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

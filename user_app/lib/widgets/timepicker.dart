import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:resize/resize.dart';
import 'package:user/constants/app_colors.dart';
import 'package:user/constants/app_strings.dart';
import 'package:user/utils/helpers/common_utils.dart';
import 'package:user/widgets/app_text.dart';

class TimePickerField extends ConsumerWidget {
  final String label;
  final TimeOfDay? selectedTime;
  final Function(TimeOfDay) onTimeSelected;
  final DateTime? selectedDate; // 👈 pass the selected date here

  const TimePickerField({
    Key? key,
    required this.label,
    required this.selectedTime,
    required this.onTimeSelected,
    required this.selectedDate, // 👈 required for date check
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
            fontWeight: FontWeight.w500,
          ),
          SizedBox(height: 4.h),
          GestureDetector(
            onTap: () async {
              CommonUtils.hideKeyBoard(context);
              // Check if date is selected
              if (selectedDate == null) {
                CommonUtils.showToast("Please select a date first.");
                return;
              }

              final picked = await showTimePicker(
                context: context,
                initialTime: selectedTime ?? TimeOfDay.now(),
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
                // ✅ Check if date is today
                if (selectedDate != null &&
                    _isSameDate(selectedDate!, DateTime.now())) {
                  final now = DateTime.now();
                  final selectedDateTime = DateTime(
                    selectedDate!.year,
                    selectedDate!.month,
                    selectedDate!.day,
                    picked.hour,
                    picked.minute,
                  );

                  final minAllowedTime = now.add(const Duration(minutes: 30));

                  if (selectedDateTime.isBefore(minAllowedTime)) {
                    CommonUtils.showToast(
                      "Please select a time at least 30 minutes from now.",
                    );
                    return;
                  }
                }

                onTimeSelected(picked);
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.backgroundGrey,
                border: Border.all(color: AppColors.greyBorder),
                borderRadius: BorderRadius.circular(5),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedTime != null
                        ? _formatTime(selectedTime!)
                        : "Select Time",
                    style: TextStyle(
                      color:
                          selectedTime != null
                              ? Colors.black
                              : AppColors.hintColor,
                      fontFamily: AppStringsKey.poppins,
                    ),
                  ),
                  Icon(Icons.access_time, size: 18, color: AppColors.hintColor),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  bool _isBefore(TimeOfDay t1, TimeOfDay t2) {
    return t1.hour < t2.hour || (t1.hour == t2.hour && t1.minute < t2.minute);
  }

  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('hh:mm a').format(dt);
  }
}

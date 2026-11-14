import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resize/resize.dart';
import 'package:user/constants/app_colors.dart';
import 'package:user/constants/app_strings.dart';
import 'package:user/di/di.dart';
import 'package:user/features/serviceProvider/data/models/appointment_request_model.dart';
import 'package:user/features/serviceProvider/data/models/providers_list_model.dart';
import 'package:user/features/serviceProvider/presentation/provider/appointment_provider.dart'
    show AppointmentProvider;
import 'package:user/features/serviceProvider/presentation/screens/apoointmentsummary_screen.dart';
import 'package:user/utils/helpers/common_utils.dart';
import 'package:user/utils/services/prefs.dart';
import 'package:user/widgets/app_bar.dart';
import 'package:user/widgets/app_button.dart';
import 'package:user/widgets/app_text.dart';
import 'package:user/widgets/app_text_field.dart';
import 'package:user/widgets/datepicker.dart';
import 'package:user/widgets/timepicker.dart';

class BookAppointmentScreen extends ConsumerStatefulWidget {
  final dynamic provider;
  final String subCategoryId;

  const BookAppointmentScreen({
    super.key,
    required this.provider,
    required this.subCategoryId,
  });

  @override
  ConsumerState<BookAppointmentScreen> createState() =>
      _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends ConsumerState<BookAppointmentScreen> {
  @override
  void initState() {
    super.initState();
    // Access form provider and pre-fill data
    final form = ref.read(appointmentProvider);

    final fullName = Prefs().getString(Prefs.fullName) ?? "";
    final phoneNumber = Prefs().getString(Prefs.mobile) ?? "";
    log(" widget.subCategoryId.toString(),:${widget.subCategoryId.toString()}");
    // Prefill name & phone
    form.nameController.text = fullName;
    form.phoneController.text = phoneNumber;
  }

  bool _isSameDate(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }

  @override
  Widget build(BuildContext context) {
    final mappointmentProvider = ref.watch(appointmentProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              title: "Book Appointment",
              leadingIconHeight: 22.5.h,
              textSize: 16.sp,
              showLeadingIcon: true,
              leadingIconEnabled: true,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Form(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText("Your Name", fontWeight: FontWeight.w500),
                        SizedBox(height: 5.h),
                        PrimaryTextField(
                          mappointmentProvider.nameController,
                          hint: "Full Name",
                          maxLines: 1,
                          type: TextInputType.text,
                          autoValidateMode: AutovalidateMode.onUserInteraction,
                          inputFormatter: [
                            FilteringTextInputFormatter.deny(
                              RegExp(r'^[\s]+'),
                            ), // No leading spaces
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Z ]'),
                            ), // Only letters and space
                          ],
                          onChanged: (val) {
                            if (val.isNotEmpty) {
                              // Convert to Camel Case automatically
                              final words = val.split(" ");
                              final camelCase = words
                                  .map((word) {
                                    if (word.isEmpty) return '';
                                    return word[0].toUpperCase() +
                                        word.substring(1).toLowerCase();
                                  })
                                  .join(" ");

                              // Update controller text with proper cursor position
                              mappointmentProvider
                                  .nameController
                                  .value = TextEditingValue(
                                text: camelCase,
                                selection: TextSelection.collapsed(
                                  offset: camelCase.length,
                                ),
                              );
                            }
                          },
                        ),
                        SizedBox(height: 15.h),

                        AppText("Contact Number", fontWeight: FontWeight.w500),
                        SizedBox(height: 5.h),
                        PrimaryTextField(
                          mappointmentProvider.phoneController,
                          maxLength: 10,
                          autoValidateMode: AutovalidateMode.onUserInteraction,
                          type: TextInputType.phone,
                          inputFormatter: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),

                        SizedBox(height: 15.h),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DatePickerField(
                              label: "Preferred Date",
                              selectedDate: mappointmentProvider.date,
                              onDateSelected: (date1) {
                                setState(() {
                                  mappointmentProvider.date = date1;
                                });
                              },
                            ),
                            SizedBox(width: 15.w),
                            TimePickerField(
                              label: "Preferred Time",
                              selectedTime: mappointmentProvider.time,
                              selectedDate:
                                  mappointmentProvider
                                      .date, // 👈 pass date here
                              onTimeSelected: (time1) {
                                setState(() {
                                  mappointmentProvider.time = time1;
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 15.h),
                        AppText("Description", fontWeight: FontWeight.w500),
                        SizedBox(height: 5.h),

                        PrimaryTextField(
                          mappointmentProvider.descriptionController,
                          maxLines: null,
                          hint: "Add a description",
                          minline: 4,
                          maxLength: 255,
                          inputFormatter: [NoLeadingSpaceFormatter()],
                        ),

                        SizedBox(height: 25.h),

                        AppPrimaryButton(
                          text: "Submit",
                          textSize: 14.sp,
                          showLoader: mappointmentProvider.isLoading,
                          onTap:
                              mappointmentProvider.isLoading
                                  ? null
                                  : () async {
                                    CommonUtils.hideKeyBoard(context);

                                    if (!mappointmentProvider.isValid()) {
                                      CommonUtils.showToast(
                                        "Please fill all fields",
                                      );
                                      return;
                                    }

                                    final date = mappointmentProvider.date;
                                    final time = mappointmentProvider.time;

                                    if (date == null || time == null) {
                                      CommonUtils.showToast(
                                        "Please select both date and time",
                                      );
                                      return;
                                    }
                                    final now =
                                        DateTime.now(); // <-- define 'now' here

                                    final appointmentDateTime = DateTime(
                                      date.year,
                                      date.month,
                                      date.day,
                                      time.hour,
                                      time.minute,
                                    );

                                    if (_isSameDate(date, now)) {
                                      final minAllowedTime = now.add(
                                        const Duration(minutes: 30),
                                      );
                                      if (appointmentDateTime.isBefore(
                                        minAllowedTime,
                                      )) {
                                        CommonUtils.showToast(
                                          "Please select a time at least 30 minutes from now.",
                                        );
                                        return;
                                      }
                                    }

                                    // Format datetime: yyyy-MM-dd HH:mm:ss
                                    final formattedDateTime =
                                        "${appointmentDateTime.year.toString().padLeft(4, '0')}-"
                                        "${appointmentDateTime.month.toString().padLeft(2, '0')}-"
                                        "${appointmentDateTime.day.toString().padLeft(2, '0')} "
                                        "${appointmentDateTime.hour.toString().padLeft(2, '0')}:"
                                        "${appointmentDateTime.minute.toString().padLeft(2, '0')}:00";

                                    // Create request object
                                    final appointmentRequest =
                                        AppointmentRequest(
                                          userId:
                                              Prefs().getString(Prefs.userId) ??
                                              '',
                                          providerId:
                                              widget.provider.providerID
                                                  .toString(),
                                          serviceId:
                                              widget.subCategoryId.toString(),
                                          appointmentTime: formattedDateTime,
                                          notes:
                                              mappointmentProvider
                                                  .descriptionController
                                                  .text,
                                          userName:
                                              mappointmentProvider
                                                  .nameController
                                                  .text,
                                          userContactEmail:
                                              Prefs().getString(Prefs.email) ??
                                              '',
                                          userContactPhone:
                                              mappointmentProvider
                                                  .phoneController
                                                  .text,
                                          providerContactEmail:
                                              widget.provider.emailAddress ??
                                              '',
                                          providerContactPhone:
                                              widget.provider.phoneNumber ?? '',
                                        );

                                    // Log for debugging
                                    print(
                                      "Appointment Request: ${appointmentRequest.toJson()}",
                                    );

                                    await mappointmentProvider.addAppointment(
                                      appointmentRequest.toJson(),
                                      widget.provider,
                                    );
                                  },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

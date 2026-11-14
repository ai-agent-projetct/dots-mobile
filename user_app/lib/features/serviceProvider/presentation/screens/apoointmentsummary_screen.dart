import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:resize/resize.dart';
import 'package:user/config/app_routes.dart';
import 'package:user/constants/app_colors.dart';
import 'package:user/constants/app_strings.dart';
import 'package:user/di/di.dart';
import 'package:user/features/home/presentation/screens/bottom_navigation.dart';
import 'package:user/features/serviceProvider/data/models/appointment_response_model.dart';
import 'package:user/features/serviceProvider/data/models/providers_list_model.dart';
import 'package:user/widgets/app_text.dart';

class AppointmentSummaryScreen extends ConsumerStatefulWidget {
  final AppointmentData data;
  final ProvidersData providerData;

  const AppointmentSummaryScreen({
    super.key,
    required this.data,
    required this.providerData,
  });

  @override
  ConsumerState<AppointmentSummaryScreen> createState() =>
      _AppointmentSummaryScreenState();
}

class _AppointmentSummaryScreenState
    extends ConsumerState<AppointmentSummaryScreen> {
  @override
  Widget build(BuildContext context) {
    final DateTime appointmentDateTime = DateTime.parse(
      widget.data.appointmentTime,
    );

    final String formattedDate = DateFormat(
      'dd/MM/yyyy',
    ).format(appointmentDateTime);
    final String formattedTime = DateFormat(
      'hh:mm a',
    ).format(appointmentDateTime);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 40.h),

                // Top Icon
                Center(
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/images/appointmentconfirm.png",
                        height: 80.h,
                      ),
                      SizedBox(height: 15.h),
                      AppText(
                        "Your Appointment is Confirmed!",
                        textStyle: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      AppText(
                        "Thank you for booking with us.\nYour appointment details are below.",
                        textAlign: TextAlign.center,
                        textStyle: TextStyle(
                          color: Colors.black54,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 30.h),

                // Appointment Summary Card
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.w),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundGrey,
                    borderRadius: BorderRadius.circular(5.r),
                    border: Border.all(color: AppColors.greyBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: AppText(
                          "Appointment Summary",
                          textStyle: TextStyle(
                            fontSize: 14.sp,
                            fontFamily: AppStringsKey.poppins,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Divider(color: AppColors.greyBorder),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _rowItem(
                              "Service:",
                              widget
                                  .providerData
                                  .subCategoryResponseModel!
                                  .subCategoryName,
                              rightTitle: "Date:",
                              rightValue: formattedDate,
                            ),
                            SizedBox(height: 5.h),
                            _rowItem(
                              "Provider:",
                              '${widget.providerData.firstName} ${widget.providerData.lastName} ',
                              rightTitle: "Time:",
                              rightValue: formattedTime,
                            ),
                            SizedBox(height: 5.h),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Appointment Id: ",
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontFamily: AppStringsKey.poppins,
                                      color: Colors.black87,
                                      fontWeight:
                                          FontWeight.bold, // Bold for the label
                                    ),
                                  ),
                                  TextSpan(
                                    text: widget.data.appointmentToken,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontFamily: AppStringsKey.poppins,
                                      color: Colors.black87,
                                      fontWeight:
                                          FontWeight
                                              .normal, // Normal for the note
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 5.h),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Description: ",
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontFamily: AppStringsKey.poppins,
                                      color: Colors.black87,
                                      fontWeight:
                                          FontWeight.bold, // Bold for the label
                                    ),
                                  ),
                                  TextSpan(
                                    text: widget.data.notes,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontFamily: AppStringsKey.poppins,
                                      color: Colors.black87,
                                      fontWeight:
                                          FontWeight
                                              .normal, // Normal for the note
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                //   const Spacer(),
                SizedBox(height: 30.h),

                // Back to Explore Button
                Container(
                  margin: const EdgeInsets.all(10),
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primary),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  const BottomNavigationScreen(initialIndex: 0),
                        ),
                        (route) => false,
                      );
                    },
                    child: AppText(
                      "Back to Explore",
                      textStyle: TextStyle(
                        color: AppColors.black,
                        fontSize: 14.sp,
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

  Widget _rowItem(
    String title,
    String value, {
    String? rightTitle,
    String? rightValue,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        // Left Side (Service/Provider)
        Expanded(
          flex: 1,
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "$title",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12.sp,
                    fontFamily: AppStringsKey.poppins,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: ' $value',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontFamily: AppStringsKey.poppins,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Vertical Divider
        Container(
          height: 15.h,
          width: 2,
          color: AppColors.greyBorder,
          margin: EdgeInsets.symmetric(horizontal: 8.w),
        ),

        // Right Side (Date/Time)
        if (rightTitle != null && rightValue != null)
          Expanded(
            flex: 1,
            child: RichText(
              textAlign: TextAlign.start, // aligns labels consistently
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "$rightTitle ",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12.sp,
                      fontFamily: AppStringsKey.poppins,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: rightValue,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontFamily: AppStringsKey.poppins,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

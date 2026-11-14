import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';
import 'package:provider/constants/app_colors.dart';
import 'package:provider/constants/app_strings.dart';
import 'package:provider/di/di.dart';
import 'package:provider/widgets/app_bar.dart';
import 'package:provider/widgets/app_text.dart';
import 'package:provider/widgets/loading_widget.dart';
import 'package:resize/resize.dart'; // your DI setup

class AppointmentScreen extends ConsumerStatefulWidget {
  const AppointmentScreen({super.key});

  @override
  AppointmentScreenState createState() => AppointmentScreenState();
}

class AppointmentScreenState extends ConsumerState<AppointmentScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(appointmentProvider).fetchAppointments();
    });
  }

  @override
  Widget build(BuildContext context) {
    final mappointmentprovider = ref.watch(appointmentProvider);

    return Scaffold(
      backgroundColor: AppColors.white,

      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              title: translate(AppStringsKey.appointment),
              leadingIconHeight: 22.5.h,
              textSize: 16.sp,
              showLeadingIcon: true,
              leadingIconEnabled: true,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Expanded(
              child: Builder(
                builder: (context) {
                  if (mappointmentprovider.isLoading) {
                    return Center(child: LoadingWidget());
                  }
                  if (mappointmentprovider.errorMessage != null) {
                    return Center(
                      child: Text(
                        mappointmentprovider.errorMessage!,
                        // 'Something went wrong.',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.red,
                        ),
                      ),
                    );
                  }
                  if (mappointmentprovider.appointments.isEmpty) {
                    return Center(
                      child: Text(
                        "No appointments available right now!",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: mappointmentprovider.appointments.length,
                    itemBuilder: (context, index) {
                      final appointment =
                          mappointmentprovider.appointments[index];
                      final DateTime dateTime = DateTime.parse(
                        appointment.appointmentTime,
                      );
                      final String formattedDate = DateFormat(
                        "dd MMM, yyyy - hh.mm a",
                      ).format(dateTime);

                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 5.h,
                        ),
                        child: Container(
                          padding: EdgeInsets.all(5.w),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(5.r),
                            border: Border.all(
                              width: 1.w,
                              color: AppColors.greyStroke,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                // appointment['name']!,
                                "User",
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              SizedBox(height: 4.h),
                              AppText(appointment.notes),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AppText(
                                    formattedDate,
                                    textStyle: TextStyle(color: Colors.grey),
                                  ),
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      elevation: 0,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10.w,
                                        vertical: 4.h,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      minimumSize: Size(0, 32),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    onPressed: () {
                                      ref
                                          .read(appointmentProvider)
                                          .makePhoneCall(
                                            context,
                                            appointment.userContactPhone,
                                          );
                                    },
                                    icon: const Icon(
                                      Icons.call,
                                      color: AppColors.white,
                                    ),
                                    label: AppText(
                                      "Call",
                                      textStyle: TextStyle(
                                        color: AppColors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

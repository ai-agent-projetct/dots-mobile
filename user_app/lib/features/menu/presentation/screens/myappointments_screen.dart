import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';
import 'package:resize/resize.dart';
import 'package:user/constants/app_colors.dart';
import 'package:user/constants/app_strings.dart';
import 'package:user/di/di.dart';
import 'package:user/features/trends/presentation/screens/trends_screen.dart';
import 'package:user/widgets/app_bar.dart';
import 'package:user/widgets/loading_widget.dart';

class MyAppointmentScreen extends ConsumerStatefulWidget {
  const MyAppointmentScreen({super.key});

  @override
  ConsumerState<MyAppointmentScreen> createState() =>
      _MyAppointmentScreenState();
}

class _MyAppointmentScreenState extends ConsumerState<MyAppointmentScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _mounted = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileProvider).getAppointments();
    });

    _scrollController.addListener(() {
      final provider = ref.read(profileProvider);
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !provider.appointmentsIsLoadingMore &&
          provider.appointmentsHasMore) {
        provider.getAppointments(loadMore: true);
      }
    });
  }

  @override
  void dispose() {
    _mounted = false;
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileProv = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              title: translate(AppStringsKey.myAppointment),
              showLeadingIcon: true,
              leadingIconEnabled: true,
              leadingIconHeight: 22.5.h,
              onTap: () => Navigator.of(context).pop(),
              textSize: 16.sp,
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await ref.read(profileProvider).getAppointments();
                },
                child:
                    profileProv.isLoading
                        ? const Center(child: LoadingWidget())
                        : profileProv.errorMessage != null
                        ? Center(
                          child: buildMessage(
                            "Something went wrong.",
                            color: AppColors.red,
                          ),
                        )
                        : profileProv.appointments.isEmpty
                        ? buildMessage("No appointment available.")
                        : ListView.separated(
                          controller: _scrollController,
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 10.h,
                          ),
                          itemCount:
                              profileProv.appointments.length +
                              (profileProv.appointmentsIsLoadingMore ? 1 : 0),
                          separatorBuilder:
                              (_, __) => Divider(color: Colors.grey.shade300),
                          itemBuilder: (context, index) {
                            if (index < profileProv.appointments.length) {
                              final item = profileProv.appointments[index];
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _rowText(
                                      "Appointment ID:",
                                      item.appointmentToken ?? '',
                                      "Time:",
                                      _formatTime(
                                        item.appointmentTime.toString(),
                                      ),
                                    ),
                                    SizedBox(height: 6.h),
                                    _rowText(
                                      "Service:",
                                      item.serviceName,
                                      "Date:",
                                      _formatDate(
                                        item.appointmentTime.toString(),
                                      ),
                                    ),
                                    SizedBox(height: 6.h),
                                    _singleText("Provider:", item.providerName),
                                  ],
                                ),
                              );
                            } else {
                              // Bottom loading indicator
                              return const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Center(child: LoadingWidget()),
                              );
                            }
                          },
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _rowText(
    String leftLabel,
    String leftValue,
    String rightLabel,
    String rightValue,
  ) {
    return Row(
      children: [
        Expanded(
          child: RichText(
            text: TextSpan(
              text: "$leftLabel ",
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                fontFamily: AppStringsKey.poppins,
                color: Colors.black,
              ),
              children: [
                TextSpan(
                  text: leftValue,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 12.sp,
                    fontFamily: AppStringsKey.poppins,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          width: 120.w,
          child: RichText(
            text: TextSpan(
              text: "$rightLabel ",
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                fontFamily: AppStringsKey.poppins,
                color: Colors.black,
              ),
              children: [
                TextSpan(
                  text: rightValue,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 12.sp,
                    fontFamily: AppStringsKey.poppins,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _singleText(String label, String value) {
    return RichText(
      text: TextSpan(
        text: "$label ",
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          fontFamily: AppStringsKey.poppins,
          color: Colors.black,
        ),
        children: [
          TextSpan(
            text: value,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 12.sp,
              color: Colors.black,
              fontFamily: AppStringsKey.poppins,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateTime) {
    final date = DateTime.parse(dateTime).toLocal();
    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";
  }

  String _formatTime(String dateTime) {
    final date = DateTime.parse(dateTime).toLocal();
    return DateFormat("hh:mm a").format(date);
  }
}

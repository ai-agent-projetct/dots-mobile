import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:resize/resize.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user/constants/app_colors.dart';
import 'package:user/constants/app_constants.dart';
import 'package:user/constants/app_images.dart';
import 'package:user/di/di.dart';
import 'package:user/features/menu/data/models/notification_model.dart';
import 'package:user/features/menu/data/models/notification_response_model.dart';
import 'package:user/features/trends/presentation/screens/trends_screen.dart';
import 'package:user/widgets/app_bar.dart';
import 'package:user/widgets/app_text.dart';
import 'package:user/widgets/loading_widget.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = ref.read(profileProvider);
      provider.getUserNotifications();
    });

    _scrollController.addListener(() {
      final provider = ref.read(profileProvider);

      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !provider.isLoadingMore &&
          provider.hasMore) {
        debugPrint("📜 Pagination trigger — Loading more data...");
        provider.getUserNotifications(loadMore: true);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mProfileProvider = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppBar(
              title: translate("Notification"),
              showLeadingIcon: true,
              leadingIconEnabled: true,
              leadingIconHeight: 22.5.h,
              onTap: () => Navigator.of(context).pop(),
              textSize: 16.sp,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                child: RefreshIndicator(
                  onRefresh: () async {
                    await ref.read(profileProvider).getUserNotifications();
                  },
                  child:
                      mProfileProvider.isLoading &&
                              mProfileProvider.notificationsList.isEmpty
                          ? const Center(child: LoadingWidget())
                          : mProfileProvider.errorMessage != null
                          ? Center(
                            child: buildMessage(
                              "Something went wrong.",
                              color: AppColors.red,
                            ),
                          )
                          : mProfileProvider.notificationsList.isEmpty
                          ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(AppImages.notificationempty),
                                SizedBox(height: 16.h),
                                AppText(
                                  "You don't have any Notification",
                                  textStyle: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          )
                          : ListView.builder(
                            controller: _scrollController,
                            itemCount:
                                mProfileProvider.notificationsList.length +
                                (mProfileProvider.isLoadingMore ||
                                        !mProfileProvider.hasMore
                                    ? 1
                                    : 0),
                            itemBuilder: (context, index) {
                              if (index <
                                  mProfileProvider.notificationsList.length) {
                                return _buildNotificationCard(
                                  mProfileProvider.notificationsList[index],
                                );
                              } else if (mProfileProvider.isLoadingMore) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Center(child: LoadingWidget()),
                                );
                              }
                              // else {
                              //   return Padding(
                              //     padding: const EdgeInsets.symmetric(
                              //       vertical: 10,
                              //     ),
                              //     child: Center(
                              //       child: Text(
                              //         "No more notifications",
                              //         style: TextStyle(
                              //           color: Colors.grey,
                              //           fontSize: 12.sp,
                              //         ),
                              //       ),
                              //     ),
                              //   );
                              // }
                            },
                          ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(UserNotification item) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(AppImages.appLogo, width: 35.w, height: 35.h),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  item.title.trim(),
                  textStyle: TextStyle(fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 5.h),
                AppText(item.message.trim()),
                SizedBox(height: 5.h),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    item.formattedDateTime.trim(),
                    style: TextStyle(fontSize: 11.sp, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

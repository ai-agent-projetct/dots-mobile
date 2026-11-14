import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/widgets/app_bar.dart';
import 'package:resize/resize.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              title: "Notification",
              leadingIconHeight: 22.5.h,
              textSize: 16.sp,
              showLeadingIcon: true,
              leadingIconEnabled: true,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Center(child: Text('No Category')),
          ],
        ),
      ),
    );
  }
}

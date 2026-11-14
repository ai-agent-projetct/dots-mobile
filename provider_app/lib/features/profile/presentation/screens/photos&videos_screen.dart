import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/widgets/app_bar.dart';
import 'package:resize/resize.dart';

class photosandvideosScreen extends ConsumerStatefulWidget {
  const photosandvideosScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<photosandvideosScreen> createState() =>
      _photosandvideosScreenState();
}

class _photosandvideosScreenState extends ConsumerState<photosandvideosScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              title: "Photos and Videos",
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

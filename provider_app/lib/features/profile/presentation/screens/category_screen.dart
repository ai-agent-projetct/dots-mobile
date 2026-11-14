import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/constants/app_colors.dart';
import 'package:provider/constants/app_images.dart';
import 'package:provider/di/di.dart';
import 'package:provider/features/alert/presentation/screens/offerpost_dialogue.dart';
import 'package:provider/features/profile/presentation/widgets/addservice_dialog.dart';
import 'package:provider/widgets/app_bar.dart';
import 'package:resize/resize.dart';

class CategoryScreen extends ConsumerStatefulWidget {
  const CategoryScreen({super.key});

  @override
  CategoryScreenState createState() => CategoryScreenState();
}

class CategoryScreenState extends ConsumerState<CategoryScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   ref.read(appointmentProvider).fetchSubscriptions();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              title: "Category",
              leadingIconHeight: 22.5.h,
              textSize: 16.sp,
              showLeadingIcon: true,
              leadingIconEnabled: true,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Expanded(child: Center(child: Text('No Services'))),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        backgroundColor: AppColors.primary,
        onPressed: () async {
          final result = await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AddServiceDialog(),
          );
          if (result == true) {
            ref.read(alertProvider).getAllOffers();
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Image.asset(
            AppImages.addicon,
            fit: BoxFit.cover,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}

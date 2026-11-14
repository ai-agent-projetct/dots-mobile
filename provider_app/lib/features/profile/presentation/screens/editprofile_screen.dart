import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/config/app_routes.dart';
import 'package:provider/constants/app_colors.dart';
import 'package:provider/constants/app_strings.dart';
import 'package:provider/di/di.dart';
import 'package:provider/main.dart';
import 'package:provider/widgets/app_bar.dart';
import 'package:provider/widgets/app_button.dart';
import 'package:provider/widgets/app_text_field.dart';
import 'package:provider/widgets/show_snackbar.dart';
import 'package:resize/resize.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Load profile data once page is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileProvider).loadProfileData();
    });
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
              title: "Edit Profile",
              textSize: 16.sp,
              showLeadingIcon: true,
              leadingIconEnabled: true,
              onTap: () => Navigator.pop(context),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(10.0.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildEditableField(
                      "Phone Number",
                      mProfileProvider.phoneNumberController,
                      () => navigateToUpdateScreen(
                        "mobile",
                        mProfileProvider.phoneNumberController.text,
                        "Update Phone Number",
                        "",
                      ),
                    ),
                    SizedBox(height: 16.h),
                    _buildEditableField(
                      "Address",
                      mProfileProvider.addressController,
                      () => navigateToUpdateScreen(
                        "address",
                        mProfileProvider.addressController.text,
                        "Update Address",
                        "",
                      ),
                      maxLines: 3,
                    ),
                    SizedBox(height: 16.h),
                    _buildEditableField(
                      "Work Experience",
                      mProfileProvider.workExperienceController,
                      () => navigateToUpdateScreen(
                        "work_experience",
                        mProfileProvider.workExperienceController.text,
                        "Update Work Experience",
                        "",
                      ),
                    ),
                    SizedBox(height: 24.h),
                    AppPrimaryButton(
                      text: "Save",
                      // textSize: 16.sp,
                      onTap: () {
                        showSnackBar(message: "Profile saved successfully");
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Navigate with required data
  void navigateToUpdateScreen(
    String key,
    String data,
    String title,
    String desc,
  ) {
    final body = {'keyName': key, 'data': data, 'title': title, 'desc': desc};
    Navigator.pushNamed(
      navigatorKey.currentState!.context,
      AppRoutes.profileUpdate,
      arguments: body,
    );
  }

  Widget _buildEditableField(
    String label,
    TextEditingController controller,
    VoidCallback onEditTap, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontFamily: AppStringsKey.poppins,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 6.h),
        TextField(
          controller: controller,
          maxLines: maxLines,
          readOnly: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.backGroundGrey,
            suffixIcon: IconButton(
              icon: const Icon(Icons.edit, size: 18),
              onPressed: onEditTap,
            ),
            enabledBorder: getBorder(),
            focusedBorder: getEnabledBorder(),
          ),
        ),
      ],
    );
  }
}

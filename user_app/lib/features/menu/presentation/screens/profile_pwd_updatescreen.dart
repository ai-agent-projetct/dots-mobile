import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:resize/resize.dart';
import 'package:user/constants/app_strings.dart';
import 'package:user/di/di.dart';
import 'package:user/utils/helpers/common_utils.dart';
import 'package:user/widgets/app_bar.dart';
import 'package:user/widgets/app_button.dart';
import 'package:user/widgets/app_text_field.dart';
import 'package:user/widgets/loading_widget.dart';

class ProfilePwdUpdateScreen extends ConsumerStatefulWidget {
  const ProfilePwdUpdateScreen({super.key});

  @override
  ProfilePwdUpdateScreenState createState() => ProfilePwdUpdateScreenState();
}

class ProfilePwdUpdateScreenState
    extends ConsumerState<ProfilePwdUpdateScreen> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var mProfileProvider = ref.watch(profileProvider);
    return PopScope(
      canPop: false,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Color(0xffFFFFFF),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBar(
                title: translate(AppStringsKey.changePwd),
                textSize: 16.sp,
                showLeadingIcon: true,
                leadingIconEnabled: true,
                onTap: () {
                  Navigator.of(context).pop();
                  mProfileProvider.newPasswordTextController.clear();
                  mProfileProvider.confirmPasswordTextController.clear();
                },
              ),
              SizedBox(height: 15.h),
              Expanded(
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            PasswordTextField(
                              mProfileProvider.newPasswordTextController,
                              hint: translate(AppStringsKey.password),
                              autoValidateMode:
                                  AutovalidateMode.onUserInteraction,
                              inputFormatter: [
                                FilteringTextInputFormatter.deny(RegExp(r'\s')),
                              ],
                              validator: (pwd) {
                                if (pwd == null || pwd.isEmpty) {
                                  return null;
                                }
                                if (pwd.isNotEmpty &&
                                    !RegExp(
                                      r'[!@#$%^&*(),.?":{}|<>]',
                                    ).hasMatch(pwd)) {
                                  return translate(
                                    AppStringsKey.pwdValidationSpecial,
                                  );
                                }
                                if (pwd.isNotEmpty &&
                                    !RegExp(r'[0-9]').hasMatch(pwd)) {
                                  return translate(
                                    AppStringsKey.pwdValidationNumber,
                                  );
                                }
                                if (pwd.isNotEmpty && pwd.length < 8) {
                                  return translate(
                                    AppStringsKey.pwdValidationText,
                                  );
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 15.h),
                            PasswordTextField(
                              mProfileProvider.confirmPasswordTextController,
                              hint: translate(AppStringsKey.confirmPassword),
                              autoValidateMode:
                                  AutovalidateMode.onUserInteraction,
                              inputFormatter: [
                                FilteringTextInputFormatter.deny(RegExp(r'\s')),
                              ],
                              validator: (pwd) {
                                if (pwd == null || pwd.isEmpty) {
                                  return null;
                                }
                                if (pwd.isNotEmpty &&
                                    mProfileProvider
                                            .newPasswordTextController
                                            .text !=
                                        pwd) {
                                  return translate(AppStringsKey.passwordMatch);
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: mProfileProvider.isLoading,
                      child: LoadingWidget(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: AppPrimaryButton(
                  text: translate(AppStringsKey.updateText),
                  onTap: () async {
                    CommonUtils.hideKeyBoard(context);
                    if (formKey.currentState!.validate()) {
                      await ref
                          .read(profileProvider)
                          .updateProfile(
                            fieldName: 'Password',
                            value:
                                mProfileProvider
                                    .confirmPasswordTextController
                                    .text
                                    .toString()
                                    .trim(),
                          );
                    }
                  },
                ),
              ),
              SizedBox(height: 5.vh),
            ],
          ),
        ),
      ),
    );
  }
}

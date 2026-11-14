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
import 'package:user/widgets/app_text.dart';
import 'package:user/widgets/app_text_field.dart';
import 'package:user/widgets/show_snackbar.dart';

class ChangePwdScreen extends ConsumerStatefulWidget {
  const ChangePwdScreen({super.key});

  @override
  ChangePwdScreenState createState() => ChangePwdScreenState();
}

class ChangePwdScreenState extends ConsumerState<ChangePwdScreen> {
  @override
  Widget build(BuildContext context) {
    var mChangePwdProvider = ref.watch(authProvider);
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Color(0xffFFFFFF),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: 8.w,
              top: 8.h,
              right: 8.w,
              bottom: 8.h,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppBar(
                  title: '',
                  showLeadingIcon: true,
                  leadingIconEnabled: true,
                  onTap: () {
                    mChangePwdProvider.passwordController.clear();
                    mChangePwdProvider.confirmPasswordController.clear();
                    Navigator.pop(context);
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.w),
                  child: AppText(
                    translate(AppStringsKey.changePwd),
                    textSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 15.h),
                Padding(
                  padding: EdgeInsets.only(
                    left: 10.w,
                    right: 10.w,
                    top: 10.h,
                    bottom: 10.h,
                  ),
                  child: Form(
                    key: mChangePwdProvider.pwdChangeFormkey,
                    child: Column(
                      children: [
                        PasswordTextField(
                          mChangePwdProvider.passwordController,
                          hint: translate(AppStringsKey.password),
                          autoValidateMode: AutovalidateMode.onUserInteraction,
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
                              return translate(AppStringsKey.pwdValidationText);
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 15.h),
                        PasswordTextField(
                          mChangePwdProvider.confirmPasswordController,
                          hint: translate(AppStringsKey.confirmPassword),
                          autoValidateMode: AutovalidateMode.onUserInteraction,
                          inputFormatter: [
                            FilteringTextInputFormatter.deny(RegExp(r'\s')),
                          ],
                          validator: (pwd) {
                            if (pwd == null || pwd.isEmpty) {
                              return null;
                            }
                            if (pwd.isNotEmpty &&
                                mChangePwdProvider.passwordController.text !=
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
                SizedBox(height: 15.h),
                Padding(
                  padding: EdgeInsets.only(
                    left: 10.w,
                    right: 10.w,
                    top: 10.h,
                    bottom: 10.h,
                  ),
                  child: AppPrimaryButton(
                    text: translate(AppStringsKey.submitText),
                    textSize: 16.sp,
                    showLoader: mChangePwdProvider.isLoading,
                    onTap: () {
                      CommonUtils.hideKeyBoard(context);
                      if (mChangePwdProvider.passwordController.text.isEmpty) {
                        showSnackBar(
                          message: translate(AppStringsKey.pwdRequired),
                          bgColor: Colors.redAccent,
                        );
                      } else if (mChangePwdProvider
                          .confirmPasswordController
                          .text
                          .isEmpty) {
                        showSnackBar(
                          message: translate(AppStringsKey.reEnterPwd),
                          bgColor: Colors.redAccent,
                        );
                      } else {
                        if (mChangePwdProvider.pwdChangeFormkey.currentState!
                            .validate()) {
                          mChangePwdProvider.passwordUpdate();
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

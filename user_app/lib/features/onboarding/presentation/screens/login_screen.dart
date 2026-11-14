import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:resize/resize.dart';
import 'package:user/config/app_routes.dart';
import 'package:user/constants/app_colors.dart';
import 'package:user/constants/app_constants.dart';
import 'package:user/constants/app_images.dart';
import 'package:user/constants/app_strings.dart';
import 'package:user/di/di.dart';
import 'package:user/utils/helpers/common_utils.dart';
import 'package:user/widgets/app_button.dart';
import 'package:user/widgets/app_text.dart';
import 'package:user/widgets/app_text_field.dart';
import 'package:user/widgets/show_snackbar.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends ConsumerState<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    var mLoginProvider = ref.watch(authProvider);
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        debugPrint('pop scope called ---- $didPop');
      },
      child: Scaffold(
        backgroundColor: Color(0xffFFFFFF),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: 5.w,
              right: 5.w,
              top: 10.h,
              bottom: 10.h,
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SizedBox(
                  //   height: AppConstants.safeAreaHeight,
                  // ),
                  Container(
                    width: 110.w,
                    height: 60.h,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(AppImages.appLogo),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.w, top: 10.w),
                    child: AppText(
                      translate(AppStringsKey.loginToAnAccount),
                      textSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      textColor: AppColors.black,
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
                      key: mLoginProvider.loginFormkey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PrimaryTextField(
                            mLoginProvider.mobileOrEmailController,
                            hint: translate(AppStringsKey.mobileOrEmail),
                            type: TextInputType.visiblePassword,
                            maxLines: 1,
                            autoValidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return null;
                              }
                              bool isValidEmail = RegExp(
                                r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                              ).hasMatch(val);
                              bool isValidPhone = RegExp(
                                r'^\d{10}$',
                              ).hasMatch(val);
                              if (!isValidEmail && !isValidPhone) {
                                return translate(
                                  AppStringsKey.mobileOrEmailValidation,
                                );
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 15.h),
                          PasswordTextField(
                            mLoginProvider.loginPasswordController,
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
                          SizedBox(height: 30.h),
                          AppPrimaryButton(
                            text: translate(AppStringsKey.login),
                            textSize: 16.sp,
                            showLoader: mLoginProvider.isLoading,
                            onTap: () {
                              CommonUtils.hideKeyBoard(context);
                              if (mLoginProvider
                                      .mobileOrEmailController
                                      .text
                                      .isEmpty &&
                                  mLoginProvider
                                      .loginPasswordController
                                      .text
                                      .isEmpty) {
                                showSnackBar(
                                  message: translate(
                                    AppStringsKey.mobilePwdRequired,
                                  ),
                                  bgColor: Colors.redAccent,
                                );
                              } else if (mLoginProvider
                                  .mobileOrEmailController
                                  .text
                                  .isEmpty) {
                                showSnackBar(
                                  message: translate(
                                    AppStringsKey.mobileOrEmailRequired,
                                  ),
                                  bgColor: Colors.redAccent,
                                );
                              } else if (mLoginProvider
                                  .loginPasswordController
                                  .text
                                  .isEmpty) {
                                showSnackBar(
                                  message: translate(AppStringsKey.pwdRequired),
                                  bgColor: Colors.redAccent,
                                );
                              } else {
                                if (mLoginProvider.loginFormkey.currentState!
                                    .validate()) {
                                  mLoginProvider.userSignIn();
                                } else {
                                  showSnackBar(
                                    message: translate(
                                      AppStringsKey.invalidCredential,
                                    ),
                                    bgColor: Colors.redAccent,
                                  );
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          if (mLoginProvider
                              .mobileOrEmailController
                              .text
                              .isEmpty) {
                            showSnackBar(
                              message: translate(
                                AppStringsKey.mobileOrEmailRequired,
                              ),
                              bgColor: Colors.redAccent,
                            );
                          } else {
                            mLoginProvider.userCheck('login');
                          }
                        },
                        child: AppText(
                          translate(AppStringsKey.forgetPwd),
                          textSize: 12.sp,
                          textColor: AppColors.hyperLinkColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText(translate(AppStringsKey.dontHaveAccount)),
                      SizedBox(width: 5.w),
                      InkWell(
                        onTap: () {
                          mLoginProvider.clearLoginValues();
                          Navigator.pushNamed(context, AppRoutes.signUpScreen);
                        },
                        child: AppText(
                          translate(AppStringsKey.signup),
                          textSize: 12.sp,
                          textColor: AppColors.hyperLinkColor,
                          textDecoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        resizeToAvoidBottomInset: true,
      ),
    );
  }
}

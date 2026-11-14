import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:resize/resize.dart';
import 'package:user/constants/app_colors.dart';
import 'package:user/constants/app_constants.dart';
import 'package:user/constants/app_images.dart';
import 'package:user/constants/app_strings.dart';
import 'package:user/di/di.dart';
import 'package:user/features/onboarding/presentation/provider/auth_provider.dart';
import 'package:user/features/onboarding/presentation/widgets/terms_and_conditions_widgets.dart';
import 'package:user/utils/helpers/common_utils.dart';
import 'package:user/widgets/app_button.dart';
import 'package:user/widgets/app_text.dart';
import 'package:user/widgets/app_text_field.dart';
import 'package:user/widgets/show_snackbar.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends ConsumerState<SignUpScreen> {
  late AuthProvider mSignUpProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      mSignUpProvider.pwdFocus.addListener(() {
        if (mSignUpProvider.pwdFocus.hasFocus &&
            !mSignUpProvider.changeSuffix) {
          mSignUpProvider.pwdFocus.unfocus();
          showSnackBar(message: translate(AppStringsKey.phoneVerifyBefore));
        }
      });
      mSignUpProvider.confirmFocus.addListener(() {
        if (mSignUpProvider.confirmFocus.hasFocus &&
            !mSignUpProvider.changeSuffix) {
          mSignUpProvider.confirmFocus.unfocus();
          showSnackBar(message: translate(AppStringsKey.phoneVerifyBefore));
        }
      });
      mSignUpProvider.emailFocus.addListener(() {
        if (mSignUpProvider.emailFocus.hasFocus &&
            !mSignUpProvider.changeSuffix) {
          mSignUpProvider.emailFocus.unfocus();
          showSnackBar(message: translate(AppStringsKey.phoneVerifyBefore));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    mSignUpProvider = ref.watch(authProvider);
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
                  //SizedBox(height: AppConstants.safeAreaHeight),
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
                      translate(AppStringsKey.signUpToAnAccount),
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
                      key: mSignUpProvider.signUpFormkey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PrimaryTextField(
                            mSignUpProvider.fullNameController,
                            hint: translate(AppStringsKey.fullName),
                            maxLines: 1,
                            type: TextInputType.text,
                            autoValidateMode:
                                AutovalidateMode.onUserInteraction,
                            inputFormatter: [
                              FilteringTextInputFormatter.deny(
                                RegExp(r'^[\s]+'),
                              ), // No leading spaces
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z ]'),
                              ), // Only letters and space
                              LengthLimitingTextInputFormatter(34),
                            ],
                            onChanged: (val) {
                              if (val.isNotEmpty) {
                                // Convert to Camel Case automatically
                                final words = val.split(" ");
                                final camelCase = words
                                    .map((word) {
                                      if (word.isEmpty) return '';
                                      return word[0].toUpperCase() +
                                          word.substring(1).toLowerCase();
                                    })
                                    .join(" ");

                                // Update controller text with proper cursor position
                                mSignUpProvider
                                    .fullNameController
                                    .value = TextEditingValue(
                                  text: camelCase,
                                  selection: TextSelection.collapsed(
                                    offset: camelCase.length,
                                  ),
                                );
                              }
                            },

                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return null;
                              }
                              final length = val.trim().length;
                              if (length < 3 || length > 34) {
                                return translate(AppStringsKey.nameValidation);
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 15.h),
                          PrimaryTextField(
                            mSignUpProvider.mobileNumberController,
                            hint: translate(AppStringsKey.mobileNumber),
                            maxLength: 10,
                            autoValidateMode:
                                AutovalidateMode.onUserInteraction,
                            type: TextInputType.phone,
                            inputFormatter: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            validator: (mob) {
                              if (mob == null || mob.isEmpty) {
                                return null;
                              }
                              bool isValidPhone = RegExp(
                                r'^\d{10}$',
                              ).hasMatch(mob);
                              if (mob.isNotEmpty && !isValidPhone) {
                                return translate(
                                  AppStringsKey.mobileValidation,
                                );
                              }
                              return null;
                            },
                            onChanged: (val) {
                              mSignUpProvider.mobileNumberController.text = val;
                              if (val.length < 10) {
                                setState(() {
                                  mSignUpProvider.changeSuffix = false;
                                });
                              }
                            },
                            suffixIcon:
                                mSignUpProvider.changeSuffix == true
                                    ? Padding(
                                      padding: EdgeInsets.only(right: 10.0.w),
                                      child: Icon(
                                        Icons.verified,
                                        color: Colors.green,
                                      ),
                                    )
                                    : InkWell(
                                      onTap: () {
                                        debugPrint('verify mobile');
                                        if (mSignUpProvider
                                                .mobileNumberController
                                                .text
                                                .length ==
                                            10) {
                                          CommonUtils.hideKeyBoard(context);
                                          mSignUpProvider.userCheck('signup');
                                        } else {
                                          showSnackBar(
                                            message: translate(
                                              AppStringsKey.mobileValidation,
                                            ),
                                            bgColor: Colors.redAccent,
                                          );
                                        }
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(right: 10.0.w),
                                        child: AppText(
                                          translate(AppStringsKey.verifyText),
                                          textColor: Colors.red,
                                        ),
                                      ),
                                    ),
                            suffixIconConstraints: BoxConstraints(
                              maxHeight: 20.h,
                              maxWidth:
                                  mSignUpProvider.changeSuffix == true
                                      ? 30.w
                                      : 50.w,
                            ),
                          ),
                          SizedBox(height: 15.h),
                          PrimaryTextField(
                            mSignUpProvider.emailController,
                            focusNode: mSignUpProvider.emailFocus,
                            hint: translate(AppStringsKey.emailAddress),
                            maxLines: 1,
                            type: TextInputType.emailAddress,
                            autoValidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return null;
                              }
                              bool isValidEmail = RegExp(
                                r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                              ).hasMatch(val);
                              if (!isValidEmail) {
                                return "Enter a valid email address";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 15.h),
                          PasswordTextField(
                            mSignUpProvider.passwordController,
                            focusNode: mSignUpProvider.pwdFocus,
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
                            mSignUpProvider.confirmPasswordController,
                            focusNode: mSignUpProvider.confirmFocus,
                            hint: translate(AppStringsKey.confirmPassword),
                            inputFormatter: [
                              FilteringTextInputFormatter.deny(RegExp(r'\s')),
                            ],
                            autoValidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (pwd) {
                              if (pwd == null || pwd.isEmpty) {
                                return null;
                              }
                              if (pwd.isNotEmpty &&
                                  mSignUpProvider.passwordController.text !=
                                      pwd) {
                                return translate(AppStringsKey.passwordMatch);
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 15.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Checkbox(
                                value: mSignUpProvider.isTermsAccepted,
                                checkColor: AppColors.primary,
                                activeColor: const Color(0xffffffff),
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                visualDensity: VisualDensity(horizontal: -4.0),
                                onChanged: (bool? value) {
                                  setState(() {
                                    mSignUpProvider.isTermsAccepted =
                                        value ?? false;
                                  });
                                },
                                side: WidgetStateBorderSide.resolveWith(
                                  (states) => BorderSide(
                                    width: 1.0.w,
                                    color: Color(0xffb9b9b9),
                                  ),
                                ),
                              ),
                              SizedBox(width: 5.w),
                              TermsAndConditionsWidget(),
                            ],
                          ),
                          SizedBox(height: 15.h),
                          AppPrimaryButton(
                            text: translate(AppStringsKey.signup),
                            textSize: 16.sp,
                            showLoader: mSignUpProvider.isLoading,
                            onTap: () {
                              CommonUtils.hideKeyBoard(context);
                              if (mSignUpProvider
                                      .fullNameController
                                      .text
                                      .isEmpty &&
                                  mSignUpProvider
                                      .passwordController
                                      .text
                                      .isEmpty &&
                                  mSignUpProvider
                                      .confirmPasswordController
                                      .text
                                      .isEmpty &&
                                  mSignUpProvider
                                      .mobileNumberController
                                      .text
                                      .isEmpty &&
                                  mSignUpProvider.isTermsAccepted == false) {
                                showSnackBar(
                                  message: translate(
                                    AppStringsKey.fillAllDetails,
                                  ),
                                  bgColor: Colors.redAccent,
                                );
                              } else if (mSignUpProvider
                                  .fullNameController
                                  .text
                                  .isEmpty) {
                                showSnackBar(
                                  message: translate(
                                    AppStringsKey.nameRequired,
                                  ),
                                  bgColor: Colors.redAccent,
                                );
                              } else if (mSignUpProvider
                                  .passwordController
                                  .text
                                  .isEmpty) {
                                showSnackBar(
                                  message: translate(AppStringsKey.pwdRequired),
                                  bgColor: Colors.redAccent,
                                );
                              } else if (mSignUpProvider
                                  .confirmPasswordController
                                  .text
                                  .isEmpty) {
                                showSnackBar(
                                  message: translate(AppStringsKey.reEnterPwd),
                                  bgColor: Colors.redAccent,
                                );
                              } else if (mSignUpProvider
                                  .mobileNumberController
                                  .text
                                  .isEmpty) {
                                showSnackBar(
                                  message: translate(
                                    AppStringsKey.phoneRequired,
                                  ),
                                  bgColor: Colors.redAccent,
                                );
                              } else if (mSignUpProvider
                                      .mobileNumberController
                                      .text
                                      .isNotEmpty &&
                                  mSignUpProvider.changeSuffix == false) {
                                showSnackBar(
                                  message: translate(AppStringsKey.phoneVerify),
                                  bgColor: Colors.redAccent,
                                );
                              } else {
                                if (mSignUpProvider.isTermsAccepted == false) {
                                  showSnackBar(
                                    message: translate(
                                      AppStringsKey.acceptTerms,
                                    ),
                                    bgColor: Colors.redAccent,
                                  );
                                } else {
                                  if (mSignUpProvider.loginFormkey.currentState!
                                      .validate()) {
                                    mSignUpProvider.userSignUp();
                                  }
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText(translate(AppStringsKey.alreadyHaveAccount)),
                      SizedBox(width: 5.w),
                      InkWell(
                        onTap: () {
                          mSignUpProvider.clearSignUpValues();
                          Navigator.pop(context);
                        },
                        child: AppText(
                          translate(AppStringsKey.login),
                          textSize: 12.sp,
                          textDecoration: TextDecoration.underline,
                          textColor: AppColors.hyperLinkColor,
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

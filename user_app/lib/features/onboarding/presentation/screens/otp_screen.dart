import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:resize/resize.dart';
import 'package:user/config/app_routes.dart';
import 'package:user/constants/app_colors.dart';
import 'package:user/constants/app_constants.dart';
import 'package:user/constants/app_strings.dart';
import 'package:user/di/di.dart';
import 'package:user/main.dart';
import 'package:user/widgets/app_bar.dart';
import 'package:user/widgets/app_button.dart';
import 'package:user/widgets/app_text.dart';
import 'package:user/widgets/show_snackbar.dart';

class OTPScreen extends ConsumerStatefulWidget {
  final String? mobile;
  final String? keyName;
  const OTPScreen({super.key, this.mobile, this.keyName});

  @override
  OTPScreenState createState() => OTPScreenState();
}

class OTPScreenState extends ConsumerState<OTPScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;

  BuildContext? contexts;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authProvider).verificationId = '';
      ref.read(authProvider).otpFieldController.clear();
      ref.read(authProvider).setTimer(true);
      triggerFirebaseOtp();
    });
  }

  @override
  Widget build(BuildContext context) {
    var mOtpProvider = ref.watch(authProvider);
    var mprofileProvider = ref.watch(profileProvider);
    var mInternetProvider = ref.watch(internetProvider);
    log(widget.keyName!);

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
              left: 8.w,
              right: 8.w,
              top: 8.h,
              bottom: 8.h,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomAppBar(
                    title: '',
                    leadingIconHeight: 22.5.h,
                    showLeadingIcon: true,
                    leadingIconEnabled: true,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: AppText(
                      translate(AppStringsKey.verificationCode),
                      textSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.w, top: 10.w),
                    child: AppText(
                      translate(AppStringsKey.fourDigitCodeSent),
                      textColor: AppColors.fontGreyColor,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child:
                        widget.keyName == "signup"
                            ? AppText(
                              '+91 ${mOtpProvider.mobileNumberController.text.toString()}',
                              textColor: AppColors.fontGreyColor,
                            )
                            : widget.keyName == "profileUpdate"
                            ? AppText(
                              '+91 ${widget.mobile}',
                              textColor: AppColors.fontGreyColor,
                            )
                            : AppText(
                              '+91 ${mprofileProvider.profileUpdateTextController.text.toString()}',
                              textColor: AppColors.fontGreyColor,
                            ),
                  ),
                  SizedBox(height: 20.h),
                  PinCodeTextField(
                    appContext: context,
                    length: 6,
                    showCursor: false,
                    readOnly: false,
                    enableActiveFill: true,
                    enablePinAutofill: false,
                    controller: mOtpProvider.otpFieldController,
                    autoDisposeControllers: false,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      FilteringTextInputFormatter.deny(RegExp(r"\s")),
                    ],
                    pinTheme: PinTheme(
                      fieldOuterPadding: EdgeInsets.only(
                        left: 5.w,
                        right: 5.w,
                        top: 5.h,
                        bottom: 5.h,
                      ),
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5.r),
                      inactiveColor: AppColors.hintTextGrey,
                      activeColor: AppColors.hintTextGrey,
                      selectedColor: AppColors.hintTextGrey,
                      inactiveFillColor: AppColors.white,
                      selectedFillColor: AppColors.white,
                      activeFillColor: AppColors.white,
                      errorBorderWidth: 1.0.w,
                      borderWidth: 1.0.w,
                      activeBorderWidth: 1.0.w,
                      disabledBorderWidth: 1.0.w,
                      inactiveBorderWidth: 1.0.w,
                      selectedBorderWidth: 1.0.w,
                      fieldHeight: AppConstants.screenWidth * 0.7 / 6,
                      fieldWidth: AppConstants.screenWidth * 0.7 / 6,
                    ),
                  ),
                  SizedBox(height: 25.h),
                  Padding(
                    padding: EdgeInsets.only(left: 10.w, right: 10.w),
                    child: AppPrimaryButton(
                      text: translate(AppStringsKey.submitText),
                      showLoader: mOtpProvider.isLoading,
                      textSize: 16.sp,
                      onTap: () {
                        if (mOtpProvider.otpFieldController.text.length > 5) {
                          verifyFirebaseCode(context);
                        } else {
                          showSnackBar(
                            message: translate(AppStringsKey.otpValidation),
                            bgColor: Colors.redAccent,
                          );
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 30.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap:
                            !mInternetProvider.connectionStatus.contains(
                                      ConnectivityResult.none,
                                    ) &&
                                    !mOtpProvider.isTimerStarted
                                ? () {
                                  debugPrint("Resend code tapped!");
                                  mOtpProvider.otpFieldController.clear();
                                  triggerResendFirebaseOtp();
                                }
                                : null,
                        child: AppText(
                          mOtpProvider.isTimerStarted
                              ? translate(AppStringsKey.resendCodeIn)
                              : translate(AppStringsKey.resendCode),
                          textColor:
                              mOtpProvider.isTimerStarted
                                  ? AppColors.fontGreyColor
                                  : AppColors.primary,
                        ),
                      ),
                      Visibility(
                        visible: mOtpProvider.isTimerStarted,
                        child: Padding(
                          padding: EdgeInsets.only(left: 5.w),
                          child: TweenAnimationBuilder<Duration>(
                            duration: Duration(seconds: 60),
                            tween: Tween(
                              begin: Duration(seconds: 60),
                              end: const Duration(seconds: 1),
                            ),
                            onEnd: () {
                              mOtpProvider.setTimer(false);
                            },
                            builder: (
                              BuildContext context,
                              Duration value,
                              Widget? child,
                            ) {
                              final minutes = value.inMinutes
                                  .remainder(60)
                                  .toString()
                                  .padLeft(2, '0');
                              final seconds = value.inSeconds
                                  .remainder(60)
                                  .toString()
                                  .padLeft(2, '0');
                              return AppText(
                                '$minutes:$seconds',
                                textColor: AppColors.primary,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> triggerFirebaseOtp() async {
    if (!mounted) return;

    try {
      ref.read(authProvider).isTimerStarted = true;
      ref.read(authProvider).setLoader(true);

      debugPrint(
        'Sending Mobile number to Firebase ${ref.read(authProvider).countryCode} ${widget.mobile}',
      );

      await auth.verifyPhoneNumber(
        phoneNumber: '${ref.read(authProvider).countryCode} ${widget.mobile}',
        timeout: const Duration(seconds: 60),

        verificationCompleted: (PhoneAuthCredential credential) {
          debugPrint('Firebase auth completed: ${credential.asMap()}');
          if (mounted) {
            ref.read(authProvider).setLoader(false);
          }
        },

        verificationFailed: (FirebaseAuthException e) {
          debugPrint('Firebase auth failed: ${e.message}');
          if (mounted) {
            ref.read(authProvider).setLoader(false);
            showSnackBar(message: e.message ?? "Verification failed");
          }
        },

        codeSent: (String verificationId, int? resendToken) {
          debugPrint('Firebase code sent');
          if (mounted) {
            ref.read(authProvider).verificationId = verificationId;
            ref.read(authProvider).setLoader(false);
          }
        },

        codeAutoRetrievalTimeout: (String verificationId) {
          debugPrint('Firebase OTP retrieval timeout reached.');
          if (mounted) {
            ref.read(authProvider).verificationId = verificationId;
            ref.read(authProvider).setLoader(false);
          }
        },
      );
    } catch (e, stack) {
      debugPrint('Unexpected error in triggerFirebaseOtp: $e\n$stack');
      if (mounted) {
        showSnackBar(message: "Something went wrong. Please try again.");
      }
    } finally {
      // Safety check in case loader wasn't stopped
      if (mounted && ref.read(authProvider).isTimerStarted) {
        ref.read(authProvider).setLoader(false);
      }
    }
  }

  Future<void> verifyFirebaseCode(BuildContext context) async {
    final verificationId = ref.read(authProvider).verificationId;
    contexts = navigatorKey.currentState!.context;

    if (verificationId.isEmpty) {
      debugPrint('Error: Verification ID is null or empty.');
      showSnackBar(
        message: "Unable to verify. Please request a new OTP.",
        bgColor: Colors.redAccent,
      );
      return;
    }

    try {
      ref.read(authProvider).setLoader(true);

      AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: ref.read(authProvider).otpFieldController.text,
      );

      UserCredential userCredential = await auth.signInWithCredential(
        credential,
      );

      debugPrint('$userCredential');
      ref.read(authProvider).setLoader(false);

      if (context.mounted) {
        Navigator.of(context).pop();
      }
      ref.read(authProvider).otpFieldController.clear();

      if (widget.keyName == 'profileUpdate') {
        Navigator.pushNamed(contexts!, AppRoutes.profilePwdUpdate);
      } else {
        ref.read(authProvider).changeSuffix = true;
      }
    } catch (e) {
      debugPrint('Error during signInWithCredential: $e');
      ref.read(authProvider).setLoader(false);
      showSnackBar(
        message: "Invalid OTP. Please try again.",
        bgColor: Colors.redAccent,
      );
    }
  }

  triggerResendFirebaseOtp() async {
    if (!mounted) return;
    ref.read(authProvider).isTimerStarted = true;
    ref.read(authProvider).setLoader(true);
    debugPrint(
      '8888:mobile:${ref.read(authProvider).countryCode} ${widget.mobile.toString()}',
    );
    await auth.verifyPhoneNumber(
      phoneNumber:
          '${ref.read(authProvider).countryCode} ${widget.mobile.toString()}',
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) {
        debugPrint('Firebase auth completed: ${credential.asMap()}');
        if (mounted) {
          ref.read(authProvider).setLoader(false);
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        debugPrint('Firebase auth failed: ${e.message.toString()}');
        if (mounted) {
          ref.read(authProvider).setLoader(false);
          showSnackBar(message: e.message.toString());
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        debugPrint('Firebase code sent');
        if (mounted) {
          ref.read(authProvider).verificationId = verificationId;
          ref.read(authProvider).setLoader(false);
          ref.read(authProvider).resendToken = resendToken!;
        }
      },
      forceResendingToken: ref.read(authProvider).resendToken,
      codeAutoRetrievalTimeout: (String verificationId) {
        if (mounted) {
          ref.read(authProvider).verificationId = verificationId;
        }
      },
    );
  }
}

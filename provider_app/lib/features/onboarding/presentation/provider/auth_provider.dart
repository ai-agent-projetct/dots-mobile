import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/config/app_routes.dart';
import 'package:provider/constants/app_strings.dart';
import 'package:provider/features/onboarding/data/models/signuprequest_model.dart';
import 'package:provider/features/onboarding/domain/usecase/check_user_usecase.dart';
import 'package:provider/features/onboarding/domain/usecase/login_usecase.dart';
import 'package:provider/features/onboarding/domain/usecase/logout_usecase.dart';
import 'package:provider/features/onboarding/domain/usecase/password_update_usecase.dart';
import 'package:provider/features/onboarding/domain/usecase/register_usecase.dart';
import 'package:provider/features/subscription/presentaion/widgets/addsubscription_dialog.dart';
import 'package:provider/main.dart';
import 'package:provider/utils/services/prefs.dart';
import 'package:provider/widgets/show_snackbar.dart';

class AuthProvider extends ChangeNotifier {
  final LoginUsecase loginUsecase;
  final RegisterUsecase registerUsecase;
  final CheckUserUsecase checkUserUsecase;
  final PasswordUpdateUsecase passwordUpdateUsecase;
  final LogoutUsecase logoutUsecase;

  final GlobalKey<FormState> loginFormkey = GlobalKey<FormState>();
  final GlobalKey<FormState> signUpFormkey = GlobalKey<FormState>();
  final GlobalKey<FormState> pwdChangeFormkey = GlobalKey<FormState>();

  //login text controller
  final mobileOrEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();

  //otp text controller
  final otpFieldController = TextEditingController();

  //signup text controller
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final mobileNumberController = TextEditingController();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final gstNumberController = TextEditingController();
  final addressController = TextEditingController();

  LatLng? selectedLatLng;

  List<String> selectedSubCategoryIds = [];

  void setLatLng(LatLng latLng) {
    selectedLatLng = latLng;
    notifyListeners(); // Optional if UI depends on it
  }

  String selectedImage = "";

  final FocusNode emailFocus = FocusNode();
  final FocusNode pwdFocus = FocusNode();
  final FocusNode confirmFocus = FocusNode();
  final FocusNode gstFocus = FocusNode();
  final FocusNode addressFocus = FocusNode();
  final FocusNode idProofFocus = FocusNode();

  var isLoading = false;
  bool isTermsAccepted = false;

  bool changeSuffix = false;

  BuildContext? context;

  var isTimerStarted = false;
  String verificationId = '';
  int resendToken = 0;
  String countryCode = '+91';

  AuthProvider(
    this.loginUsecase,
    this.registerUsecase,
    this.checkUserUsecase,
    this.passwordUpdateUsecase,
    this.logoutUsecase,
  );

  setLoader(bool isLoading) {
    this.isLoading = isLoading;
    notifyListeners();
  }

  clearLoginValues() {
    mobileOrEmailController.clear();
    loginPasswordController.clear();
    notifyListeners();
  }

  clearSignUpValues() {
    firstNameController.clear();
    lastNameController.clear();
    confirmPasswordController.clear();
    passwordController.clear();
    emailController.clear();
    addressController.clear();
    mobileNumberController.clear();
    selectedImage = "";
    gstNumberController.clear();
    otpFieldController.clear();
    isTermsAccepted = false;
    changeSuffix = false;
    notifyListeners();
  }

  Future<void> userCheck(key) async {
    log("check user key:$key");
    setLoader(true);
    bool isValidPhone = RegExp(
      r'^\d{10}$',
    ).hasMatch(mobileOrEmailController.text);
    var body = {
      'Email_Address':
          key == 'signup'
              ? ""
              : !isValidPhone
              ? mobileOrEmailController.text
              : "",
      'Phone_number':
          key == 'signup'
              ? mobileNumberController.text
              : isValidPhone
              ? mobileOrEmailController.text
              : "",
    };
    try {
      var data = await checkUserUsecase.userCheck(body);
      context = navigatorKey.currentState!.context;
      if (data.isLeft()) {
        setLoader(false);
        showSnackBar(message: data.getLeft().error);
      } else {
        var checkData = data.getRight().data;
        if (checkData != null && checkData.isUserExists) {
          if (key == 'login') {
            Navigator.pushNamed(context!, AppRoutes.changePwd);
          } else {
            showSnackBar(message: translate(AppStringsKey.userExists));
          }
        } else if (checkData != null && !checkData.isUserExists) {
          if (key == 'signup') {
            var body = {
              'keyName': key,
              'mobile': mobileNumberController.text.toString(),
            };
            Navigator.pushNamed(context!, AppRoutes.otp, arguments: body);
          } else {
            showSnackBar(message: translate(AppStringsKey.userNotExists));
          }
        } else {
          showSnackBar(message: data.getRight().msg.toString());
        }
        setLoader(false);
      }
    } catch (e) {
      setLoader(false);
      debugPrint('Auth provider check user catch error ${e.toString()}');
    }
  }

  Future<void> userSignIn() async {
    setLoader(true);
    bool isValidPhone = RegExp(
      r'^\d{10}$',
    ).hasMatch(mobileOrEmailController.text);
    var body = {
      'Email_Address': !isValidPhone ? mobileOrEmailController.text : "",
      'Phone_number': isValidPhone ? mobileOrEmailController.text : "",
      'Password': loginPasswordController.text,
    };
    try {
      var data = await loginUsecase.userLogin(body);
      context = navigatorKey.currentState!.context;
      print(data);

      if (data.isLeft()) {
        print(data);
        showSnackBar(message: data.getLeft().error);
        setLoader(false);
      } else {
        var userData = data.getRight().data;
        final status = userData.subscriptionStatus?.toLowerCase() ?? "";

        print(userData);
        Prefs().setString(Prefs.firstName, userData.firstName.toString());
        Prefs().setString(Prefs.lastName, userData.lastName.toString());
        Prefs().setString(Prefs.email, userData.emailAddress.toString());
        Prefs().setString(Prefs.token, userData.token.toString());
        Prefs().setString(
          Prefs.profileImage,
          userData.profileImage.toString() ?? '',
        );
        Prefs().setString(Prefs.address, userData.address.toString());
        Prefs().setString(Prefs.latitude, userData.latitude.toString());
        Prefs().setString(Prefs.longitude, userData.longitude.toString());
        Prefs().setString(Prefs.gst, userData.gst.toString());
        Prefs().setString(Prefs.userId, userData.providerId.toString());
        Prefs().setString(Prefs.mobile, userData.phoneNumber.toString());
        Prefs().setString(Prefs.roleId, userData.roleId.toString());

        setLoader(false);

        if (status == "subscribed") {
          // Navigate to Bottom Navigation
          await Prefs().setBool(Prefs.isLogin, true);
          await Navigator.pushNamedAndRemoveUntil(
            context!,
            AppRoutes.bottomNavigation,
            (Route route) => false,
          );
          clearLoginValues();
        } else if (status == "nosubscription") {
          await showDialog(
            barrierDismissible: false,
            // ignore: use_build_context_synchronously
            context: navigatorKey.currentState!.context,
            builder:
                (BuildContext context) =>
                    const AddSubscriptionDialog(loginKey: "login"),
          );
        } else if (status == "pending") {
          await Navigator.pushNamed(context!, AppRoutes.approvalPending);
        }
        clearLoginValues();
      }
    } catch (e) {
      setLoader(false);
      debugPrint('Auth provider sign in catch error ${e.toString()}');
    }
  }

  Future<void> userSignUp() async {
    setLoader(true);

    final request = SignUpRequest(
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      emailAddress: emailController.text.trim(),
      password: passwordController.text.trim(),
      phoneNumber: mobileNumberController.text,
      address: addressController.text.trim(),
      latitude: selectedLatLng!.latitude,
      longitude: selectedLatLng!.longitude,
      services: selectedSubCategoryIds,
      idProof: selectedImage,
      gst: gstNumberController.text.trim(),
    );

    print(request.toJson());

    try {
      var data = await registerUsecase.userRegister(request.toJson());
      context = navigatorKey.currentState!.context;
      if (data.isLeft()) {
        setLoader(false);
        showSnackBar(message: data.getLeft().error);
      } else {
        showSnackBar(message: data.getRight().msg.toString());
        setLoader(false);
        clearSignUpValues();
        Navigator.pop(context!);
      }
    } catch (e) {
      setLoader(false);
      debugPrint('Auth provider sign up catch error ${e.toString()}');
    }
  }

  Future<void> passwordUpdate() async {
    setLoader(true);
    bool isValidPhone = RegExp(
      r'^\d{10}$',
    ).hasMatch(mobileOrEmailController.text);
    var body = {
      'Email_Address': !isValidPhone ? mobileOrEmailController.text : "",
      'Phone_number': isValidPhone ? mobileOrEmailController.text : "",
      'Password': confirmPasswordController.text.toString(),
    };
    try {
      var data = await passwordUpdateUsecase.pwdUpdate(body);
      context = navigatorKey.currentState!.context;
      if (data.isLeft()) {
        showSnackBar(message: data.getLeft().error);
        setLoader(false);
      } else {
        showSnackBar(message: data.getRight().msg.toString());
        passwordController.clear();
        confirmPasswordController.clear();
        Navigator.pop(context!);
        setLoader(false);
      }
    } catch (e) {
      setLoader(false);
      debugPrint('Auth provider pwd update catch error ${e.toString()}');
    }
  }

  void userSignOut(BuildContext context) async {
    notifyListeners();

    Prefs().setBool(Prefs.isLogin, false);
    Prefs().clearIndividualSharedPref(Prefs.firstName);
    Prefs().clearIndividualSharedPref(Prefs.lastName);
    Prefs().clearIndividualSharedPref(Prefs.token);
    Prefs().clearIndividualSharedPref(Prefs.fcmToken);
    Prefs().clearIndividualSharedPref(Prefs.email);
    Prefs().clearIndividualSharedPref(Prefs.profileImage);
    Prefs().clearIndividualSharedPref(Prefs.address);
    Prefs().clearIndividualSharedPref(Prefs.latitude);
    Prefs().clearIndividualSharedPref(Prefs.longitude);
    Prefs().clearIndividualSharedPref(Prefs.gst);
    Prefs().clearIndividualSharedPref(Prefs.mobile);
    Prefs().clearIndividualSharedPref(Prefs.userId);

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.loginScreen,
      (Route<dynamic> route) => false,
    );

    notifyListeners();
  }

  setTimer(bool isTimerStarted) {
    this.isTimerStarted = isTimerStarted;
    notifyListeners();
  }

  bool isVerifying = false;

  void startVerifying() {
    isVerifying = true;
    notifyListeners();
  }

  void stopVerifying() {
    isVerifying = false;
    notifyListeners();
  }
}

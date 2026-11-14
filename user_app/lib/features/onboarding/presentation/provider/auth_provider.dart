import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:user/config/app_routes.dart';
import 'package:user/constants/app_colors.dart';
import 'package:user/constants/app_strings.dart';
import 'package:user/features/onboarding/domain/usecase/check_user_usecase.dart';
import 'package:user/features/onboarding/domain/usecase/login_usecase.dart';
import 'package:user/features/onboarding/domain/usecase/password_update_usecase.dart';
import 'package:user/features/onboarding/domain/usecase/register_usecase.dart';
import 'package:user/main.dart';
import 'package:user/utils/services/prefs.dart';
import 'package:user/widgets/show_snackbar.dart';

class AuthProvider extends ChangeNotifier {
  final LoginUsecase loginUsecase;
  final RegisterUsecase registerUsecase;
  final CheckUserUsecase checkUserUsecase;
  final PasswordUpdateUsecase passwordUpdateUsecase;

  final GlobalKey<FormState> loginFormkey = GlobalKey<FormState>();
  final GlobalKey<FormState> signUpFormkey = GlobalKey<FormState>();
  final GlobalKey<FormState> pwdChangeFormkey = GlobalKey<FormState>();

  //login text controller
  final mobileOrEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();

  //otp text controller
  final otpFieldController = TextEditingController();

  //signup text controller
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final mobileNumberController = TextEditingController();

  final FocusNode emailFocus = FocusNode();
  final FocusNode pwdFocus = FocusNode();
  final FocusNode confirmFocus = FocusNode();

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
    fullNameController.clear();
    confirmPasswordController.clear();
    passwordController.clear();
    emailController.clear();
    mobileNumberController.clear();
    otpFieldController.clear();
    isTermsAccepted = false;
    changeSuffix = false;
    notifyListeners();
  }

  Future<void> userCheck(key) async {
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
        var userData = data.getRight().data!;
        showSnackBar(
          message: data.getRight().msg,
          bgColor: AppColors.oliveGreen,
        );
        print(userData);
        Prefs().setString(Prefs.fullName, userData.fullName.toString());
        Prefs().setString(Prefs.email, userData.email.toString());
        Prefs().setString(Prefs.token, userData.token.toString());
        Prefs().setString(Prefs.userImage, userData.image.toString());
        Prefs().setString(Prefs.userId, userData.userId.toString());
        Prefs().setString(Prefs.mobile, userData.mobile.toString());
        Prefs().setBool(Prefs.isLogin, true);
        setLoader(false);
        await Navigator.pushNamedAndRemoveUntil(
          context!,
          AppRoutes.bottomNavigation,
          (Route route) => false,
        );
        clearLoginValues();
      }
    } catch (e) {
      setLoader(false);
      debugPrint('Auth provider sign in catch error ${e.toString()}');
    }
  }

  Future<void> userSignUp() async {
    setLoader(true);
    var body = {
      'Full_name': fullNameController.text,
      'Email_Address': emailController.text,
      'Phone_number': mobileNumberController.text,
      'Password': confirmPasswordController.text,
    };
    try {
      var data = await registerUsecase.userRegister(body);
      context = navigatorKey.currentState!.context;
      if (data.isLeft()) {
        setLoader(false);
        showSnackBar(message: data.getLeft().error);
      } else {
        showSnackBar(
          message: data.getRight().msg.toString(),
          bgColor: AppColors.oliveGreen,
        );
        setLoader(false);
        Navigator.pop(context!);
        clearSignUpValues();
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
        showSnackBar(
          message: data.getRight().msg.toString(),
          bgColor: AppColors.oliveGreen,
        );
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

  setTimer(bool isTimerStarted) {
    this.isTimerStarted = isTimerStarted;
    notifyListeners();
  }
}

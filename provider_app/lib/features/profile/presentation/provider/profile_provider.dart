import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/config/app_routes.dart';
import 'package:provider/constants/app_constants.dart';
import 'package:provider/constants/app_strings.dart';
import 'package:provider/features/onboarding/domain/usecase/check_user_usecase.dart';
import 'package:provider/features/profile/domain/usecase/updateprofile_usecase.dart';
import 'package:provider/main.dart';
import 'package:provider/utils/services/prefs.dart';
import 'package:provider/widgets/show_snackbar.dart';

class ProfileProvider extends ChangeNotifier {
  final UpdateProfileUsecase updateProfileUsecase;
  final CheckUserUsecase checkUserUsecase;
  ProfileProvider(this.updateProfileUsecase, this.checkUserUsecase);

  BuildContext? context;
  bool isLoading = false;

  // Controllers
  final profileUpdateTextController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final addressController = TextEditingController();
  final workExperienceController = TextEditingController();

  // Profile fields
  String fullName = '';
  String email = '';
  String userImage = '';
  String userId = '';

  bool changeSuffix = false;

  /// Set loading state
  setLoader(bool value) {
    isLoading = value;
    notifyListeners();
  }

  /// Load user data from SharedPreferences
  Future<void> loadProfileData() async {
    final firstName = Prefs().getString(Prefs.firstName) ?? '';
    final lastName = Prefs().getString(Prefs.lastName) ?? '';

    fullName = '$firstName $lastName';
    email = Prefs().getString(Prefs.email) ?? '';
    userImage = Prefs().getString(Prefs.profileImage) ?? '';
    userId = Prefs().getString(Prefs.userId) ?? '';

    phoneNumberController.text = '+91 ${Prefs().getString(Prefs.mobile) ?? ''}';
    addressController.text =
        Prefs().getString("address") ??
        '34, Kamaraj Street, Near Velavan Market\nChennai - 600001';
    workExperienceController.text =
        Prefs().getString("work_experience") ?? '04';

    notifyListeners();
  }

  /// Update profile field
  Future<void> updateProfile({String? fieldName, String? value}) async {
    setLoader(true);
    final body = {fieldName: value};

    final data = await updateProfileUsecase.profileUpdate(body);
    context = navigatorKey.currentState!.context;
    setLoader(false);

    if (data.isLeft()) {
      showSnackBar(message: data.getLeft().error);
    } else {
      if (fieldName != 'profile_img') {
        Navigator.pop(context!);
      }
      showSnackBar(message: data.getRight().msg.toString());

      await loadProfileData();
    }
  }

  Future<void> userCheck(mobile, key) async {
    setLoader(true);
    var body = {'Phone_number': mobile};
    try {
      var data = await checkUserUsecase.userCheck(body);
      context = navigatorKey.currentState!.context;
      if (data.isLeft()) {
        setLoader(false);
        showSnackBar(message: data.getLeft().error);
      } else {
        var checkData = data.getRight().data;
        if (checkData != null && checkData.isUserExists) {
          if (key == 'Password') {
            var body = {'keyName': 'profileUpdate', 'mobile': mobile};
            Navigator.pushNamed(context!, AppRoutes.otp, arguments: body);
          } else {
            showSnackBar(message: translate(AppStringsKey.userExists));
          }
        } else if (checkData != null && !checkData.isUserExists) {
          if (key == ApiConstants.mobile) {
            var body = {'keyName': key, 'mobile': mobile};
            Navigator.pushNamed(context!, AppRoutes.otp, arguments: body).then((
              val,
            ) {
              changeSuffix = true;
              notifyListeners();
            });
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

  /// Sign out

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
}

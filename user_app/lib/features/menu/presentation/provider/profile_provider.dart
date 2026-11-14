import 'package:universal_io/io.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:user/config/app_routes.dart';
import 'package:user/constants/app_colors.dart';
import 'package:user/constants/app_constants.dart';
import 'package:user/constants/app_strings.dart';
import 'package:user/features/menu/data/models/appointment_response_model.dart';
import 'package:user/features/menu/data/models/notification_model.dart';
import 'package:user/features/menu/data/models/notification_response_model.dart';
import 'package:user/features/menu/data/models/profile_model.dart';
import 'package:user/features/menu/domain/usecase/file_upload_usecase.dart';
import 'package:user/features/menu/domain/usecase/getappointment_usecase.dart';
import 'package:user/features/menu/domain/usecase/logout_usecase.dart';
import 'package:user/features/menu/domain/usecase/notification_usecase.dart';
import 'package:user/features/menu/domain/usecase/profile_view_usecase.dart';
import 'package:user/features/menu/domain/usecase/update_profile_usecase.dart';
import 'package:user/features/onboarding/domain/usecase/check_user_usecase.dart';
import 'package:user/main.dart';
import 'package:user/utils/helpers/extension.dart';
import 'package:user/utils/services/prefs.dart';
import 'package:user/widgets/show_snackbar.dart';

class ProfileProvider extends ChangeNotifier {
  ProfileViewUsecase profileViewUsecase;
  FileUploadUsecase fileUploadUsecase;
  UpdateProfileUsecase updateProfileUsecase;
  LogoutUsecase logoutUsecase;
  CheckUserUsecase checkUserUsecase;
  GetAppointmentsUseacse getAppointmentsUseacse;
  GetUserNotificationUseacse getUserNotificationUseacse;

  bool isLoading = false;

  bool changeSuffix = false;

  var profileUpdateTextController = TextEditingController();
  var newPasswordTextController = TextEditingController();
  var confirmPasswordTextController = TextEditingController();

  ProfileData? profileData;
  BuildContext? context;

  ProfileProvider(
    this.profileViewUsecase,
    this.fileUploadUsecase,
    this.updateProfileUsecase,
    this.logoutUsecase,
    this.checkUserUsecase,
    this.getAppointmentsUseacse,
    this.getUserNotificationUseacse,
  );

  String userImage = '';
  String userName = '';
  String mobile = '';

  void loadPrefs() {
    userImage = Prefs.shared.getString(Prefs.userImage) ?? '';
    userName = Prefs.shared.getString(Prefs.fullName)?.capitalize() ?? 'Guest';
    mobile = Prefs.shared.getString(Prefs.mobile) ?? '';
    notifyListeners();
  }

  String? errorMessage;

  List<GetAppointment> appointments = [];
  int _appointmentsCurrentPage = 1;
  bool _appointmentsHasMore = true;
  bool _appointmentsIsLoadingMore = false;

  bool get appointmentsHasMore => _appointmentsHasMore;
  bool get appointmentsIsLoadingMore => _appointmentsIsLoadingMore;

  Future<void> getAppointments({bool loadMore = false}) async {
    debugPrint(
      "Fetching appointments — loadMore: $loadMore, page: $_appointmentsCurrentPage",
    );

    if (loadMore) {
      if (_appointmentsIsLoadingMore || !_appointmentsHasMore) {
        debugPrint(
          "Skipped API call: _appointmentsIsLoadingMore=$_appointmentsIsLoadingMore, _appointmentsHasMore=$_appointmentsHasMore",
        );
        return;
      }
      _appointmentsIsLoadingMore = true;
      _appointmentsCurrentPage++;
    } else {
      _appointmentsCurrentPage = 1;
      appointments.clear();
      setLoader(true);
    }

    try {
      errorMessage = null;

      var result = await getAppointmentsUseacse.getAppointments(
        page: _appointmentsCurrentPage,
        limit: 10,
      );

      debugPrint("API called for page $_appointmentsCurrentPage");

      if (result.isLeft()) {
        errorMessage = result.getLeft().error;
      } else {
        var response = result.getRight();
        appointments.addAll(response.data);

        _appointmentsHasMore =
            response.pagination != null &&
            _appointmentsCurrentPage < response.pagination!.totalPages;
        debugPrint("Has more appointments: $_appointmentsHasMore");
      }
    } catch (e, stack) {
      debugPrint("getAppointments error: $e\n$stack");
      errorMessage = "Unable to load appointments. Please try again.";
    } finally {
      if (!loadMore) setLoader(false);
      _appointmentsIsLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> getProfile() async {
    setLoader(true);
    var data = await profileViewUsecase.getProfileDetails();

    if (data.isLeft()) {
      setLoader(false);
      showSnackBar(message: data.getLeft().error);
    } else {
      profileData = data.getRight().data!;
      print(profileData.toString());
      Prefs().setString(Prefs.fullName, profileData!.fullName.toString());
      Prefs().setString(Prefs.email, profileData!.email.toString());
      Prefs().setString(Prefs.userImage, profileData!.image.toString());
      Prefs().setString(Prefs.mobile, profileData!.mobile.toString());
      Prefs().setString(Prefs.userId, profileData!.userId.toString());
      setLoader(false);
      changeSuffix = true;
      notifyListeners();
    }
  }

  setLoader(bool isLoading) {
    this.isLoading = isLoading;
    notifyListeners();
  }

  void uploadFile(File file) async {
    setLoader(true);
    var data = await fileUploadUsecase.fileUpload(file);
    setLoader(false);
    if (data.isLeft()) {
      showSnackBar(message: data.getLeft().error);
    } else {
      if (data.getRight().data != null) {
        updateProfile(
          fieldName: 'profile_img',
          value: data.getRight().data!.imageUrl.toString(),
        );
      }
    }
  }

  Future<void> updateProfile({String? fieldName, String? value}) async {
    setLoader(true);
    var body = {fieldName: value};
    var data = await updateProfileUsecase.profileUpdate(body);
    context = navigatorKey.currentState!.context;
    setLoader(false);
    if (data.isLeft()) {
      showSnackBar(message: data.getLeft().error);
    } else {
      showSnackBar(
        message: data.getRight().msg.toString(),
        bgColor: AppColors.oliveGreen,
      );
      if (fieldName != 'profile_img') {
        Navigator.pop(context!);
      } else {
        if (fieldName == 'Password') {
          newPasswordTextController.clear();
          confirmPasswordTextController.clear();
        } else {
          profileUpdateTextController.clear();
        }
      }
      await getProfile();
    }
  }

  void userSignOut() async {
    try {
      var body = {'User_ID': Prefs().getString(Prefs.userId)};
      var data = await logoutUsecase.signOut(body);
      context = navigatorKey.currentState!.context;
      if (data.isLeft()) {
        showSnackBar(message: data.getLeft().error);
      } else {
        Prefs().setBool(Prefs.isLogin, false);
        Prefs().clearIndividualSharedPref(Prefs.fullName);
        Prefs().clearIndividualSharedPref(Prefs.email);
        Prefs().clearIndividualSharedPref(Prefs.userImage);
        Prefs().clearIndividualSharedPref(Prefs.mobile);
        Prefs().clearIndividualSharedPref(Prefs.userId);
        Navigator.pushNamedAndRemoveUntil(
          context!,
          AppRoutes.loginScreen,
          (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      debugPrint('profile provider sign out catch error: ${e.toString()}');
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

  List<UserNotification> notificationsList = [];
  int _currentPage = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;

  Future<void> getUserNotifications({bool loadMore = false}) async {
    debugPrint(
      "Fetching notifications — loadMore: $loadMore, page: $_currentPage",
    );

    if (loadMore) {
      if (_isLoadingMore || !_hasMore) {
        debugPrint(
          "Skipped API call: _isLoadingMore=$_isLoadingMore, _hasMore=$_hasMore",
        );
        return;
      }
      _isLoadingMore = true;
      _currentPage++;
    } else {
      _currentPage = 1;
      notificationsList.clear();
      setLoader(true);
    }

    try {
      errorMessage = null;

      var result = await getUserNotificationUseacse.getUserNotifications(
        page: _currentPage,
        limit: 10,
      );

      debugPrint("API called for page $_currentPage");

      if (result.isLeft()) {
        errorMessage = result.getLeft().error;
      } else {
        var response = result.getRight();
        notificationsList.addAll(response.data);

        _hasMore =
            response.pagination != null &&
            _currentPage < response.pagination!.pages;
        debugPrint("Has more: $_hasMore");
      }
    } catch (e, stack) {
      debugPrint("getUserNotifications error: $e\n$stack");
    } finally {
      if (!loadMore) setLoader(false);
      _isLoadingMore = false;
      notifyListeners();
    }
  }
}

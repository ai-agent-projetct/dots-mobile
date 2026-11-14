import 'dart:convert';
import 'package:universal_io/io.dart';
import 'package:dio/dio.dart';
import 'package:user/constants/app_urls.dart';
import 'package:user/features/menu/data/datasource/profile_datasource.dart';
import 'package:user/features/menu/data/models/appointment_response_model.dart';
import 'package:user/features/menu/data/models/file_upload_model.dart';
import 'package:user/features/menu/data/models/notification_response_model.dart';
import 'package:user/features/menu/data/models/profile_model.dart';
import 'package:user/features/onboarding/data/models/common_response_model.dart';
import 'package:user/network/error.dart';
import 'package:user/network/extension.dart';
import 'package:user/utils/either.dart';
import 'package:user/utils/services/prefs.dart';

class ProfileDatasourceImpl implements ProfileDatasource {
  final Dio dio;

  ProfileDatasourceImpl(this.dio);

  @override
  Future<Either<Failure, ProfileResponseModel>> getProfileDetails() async {
    var result = Either<Failure, ProfileResponseModel>();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${Prefs().getString(Prefs.token)}',
    };
    try {
      var rawResponse = await dio.get(
        AppUrls.profileView,
        options: Options(headers: headers),
      );
      var response = await rawResponse.getResult();
      if (response.isLeft()) {
        result.setLeft(response.getLeft());
      } else {
        var jsonData = json.decode(response.getRight());
        if (jsonData['status'] == true) {
          var responseModel = ProfileResponseModel.fromJson(
            json.decode(response.getRight()),
          );
          result.setRight(responseModel);
        } else {
          result.setLeft(CustomError((jsonData['message']) ?? UnknownError()));
        }
      }
    } on Exception catch (e) {
      if (e is DioException) {
        result.setLeft(e.getDioError());
      }
    }
    return result;
  }

  @override
  Future<Either<Failure, FileUploadResponseModel>> fileUpload(File file) async {
    var result = Either<Failure, FileUploadResponseModel>();
    String fileName = file.path.split('/').last;
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(file.path, filename: fileName),
    });
    try {
      var rawResponse = await dio.post(
        AppUrls.fileUpload,
        data: formData,
        options: Options(),
      );
      var response = await rawResponse.getResult();
      if (response.isLeft()) {
        result.setLeft(response.getLeft());
      } else {
        var jsonData = json.decode(response.getRight());
        if (jsonData['status'] == true) {
          var responseModel = FileUploadResponseModel.fromJson(
            json.decode(response.getRight()),
          );
          result.setRight(responseModel);
        } else {
          result.setLeft(CustomError((jsonData['message']) ?? UnknownError()));
        }
      }
    } on Exception catch (e) {
      if (e is DioException) {
        result.setLeft(e.getDioError());
      }
    }
    return result;
  }

  @override
  Future<Either<Failure, CommonResponseModel>> profileUpdate(
    Map<dynamic, dynamic> body,
  ) async {
    var result = Either<Failure, CommonResponseModel>();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${Prefs().getString(Prefs.token)}',
    };
    try {
      var rawResponse = await dio.post(
        AppUrls.profileUpdate,
        data: body,
        options: Options(headers: headers),
      );
      var response = await rawResponse.getResult();
      if (response.isLeft()) {
        result.setLeft(response.getLeft());
      } else {
        var jsonData = json.decode(response.getRight());
        if (jsonData['status'] == true) {
          var responseModel = CommonResponseModel.fromJson(
            json.decode(response.getRight()),
          );
          result.setRight(responseModel);
        } else {
          result.setLeft(CustomError((jsonData['message']) ?? UnknownError()));
        }
      }
    } on Exception catch (e) {
      if (e is DioException) {
        result.setLeft(e.getDioError());
      }
    }
    return result;
  }

  @override
  Future<Either<Failure, CommonResponseModel>> logout(
    Map<dynamic, dynamic> body,
  ) async {
    var result = Either<Failure, CommonResponseModel>();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${Prefs().getString(Prefs.token)}',
    };
    try {
      var rawResponse = await dio.post(
        AppUrls.logout,
        data: body,
        options: Options(headers: headers),
      );
      var response = await rawResponse.getResult();
      if (response.isLeft()) {
        result.setLeft(response.getLeft());
      } else {
        var jsonData = json.decode(response.getRight());
        if (jsonData['status'] == true) {
          var responseModel = CommonResponseModel.fromJson(
            json.decode(response.getRight()),
          );
          result.setRight(responseModel);
        } else {
          result.setLeft(CustomError((jsonData['message']) ?? UnknownError()));
        }
      }
    } on Exception catch (e) {
      if (e is DioException) {
        result.setLeft(e.getDioError());
      }
    }
    return result;
  }

  @override
  Future<Either<Failure, GetAppointmentsResponseModel>> getAppointments({
    int page = 1,
    int limit = 10,
  }) async {
    var result = Either<Failure, GetAppointmentsResponseModel>();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${Prefs().getString(Prefs.token)}',
    };
    try {
      final url = "${AppUrls.getappointments}?page=$page&limit=$limit";

      var rawResponse = await dio.get(url, options: Options(headers: headers));
      var response = await rawResponse.getResult();
      if (response.isLeft()) {
        result.setLeft(response.getLeft());
      } else {
        var jsonData = json.decode(response.getRight());
        if (jsonData['status'] == true) {
          var responseModel = GetAppointmentsResponseModel.fromJson(
            json.decode(response.getRight()),
          );
          result.setRight(responseModel);
        } else {
          result.setLeft(CustomError((jsonData['message']) ?? UnknownError()));
        }
      }
    } on Exception catch (e) {
      if (e is DioException) {
        result.setLeft(e.getDioError());
      }
    }
    return result;
  }

  @override
  Future<Either<Failure, NotificationResponseModel>> getUserNotifications({
    int page = 1,
    int limit = 10,
  }) async {
    var result = Either<Failure, NotificationResponseModel>();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${Prefs().getString(Prefs.token)}',
    };

    try {
      final url = "${AppUrls.getUserNotifications}&page=$page&limit=$limit";
      var rawResponse = await dio.get(url, options: Options(headers: headers));

      var response = await rawResponse.getResult();
      if (response.isLeft()) {
        result.setLeft(response.getLeft());
      } else {
        var jsonData = json.decode(response.getRight());
        if (jsonData['status'] == true) {
          var responseModel = NotificationResponseModel.fromJson(jsonData);
          result.setRight(responseModel);
        } else {
          result.setLeft(CustomError((jsonData['message']) ?? UnknownError()));
        }
      }
    } on Exception catch (e) {
      if (e is DioException) {
        result.setLeft(e.getDioError());
      }
    }
    return result;
  }
}

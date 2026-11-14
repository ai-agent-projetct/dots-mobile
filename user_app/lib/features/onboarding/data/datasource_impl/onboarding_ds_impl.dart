import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:user/constants/app_urls.dart';
import 'package:user/features/onboarding/data/datasource/onboarding_datasource.dart';
import 'package:user/features/onboarding/data/models/check_user_model.dart';
import 'package:user/features/onboarding/data/models/common_response_model.dart';
import 'package:user/features/onboarding/data/models/config_model.dart';
import 'package:user/features/onboarding/data/models/login_model.dart';
import 'package:user/features/onboarding/data/models/register_model.dart';
import 'package:user/network/error.dart';
import 'package:user/network/extension.dart';
import 'package:user/utils/either.dart';

class OnboardingDatasourceImpl implements OnboardingDatasource {
  final Dio dio;

  OnboardingDatasourceImpl(this.dio);

  @override
  Future<Either<Failure, ConfigModel>> getConfig() async {
    var result = Either<Failure, ConfigModel>();
    try {
      var rawResponse = await dio.get(AppUrls.configUrl);
      var response = await rawResponse.getResult();
      if (response.isLeft()) {
        result.setLeft(response.getLeft());
      } else {
        var jsonData = json.decode(response.getRight());
        if (jsonData['status'] == true) {
          var responseModel =
              ConfigModel.fromJson(json.decode(response.getRight()));
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
  Future<Either<Failure, LoginResponseModel>> login(
      Map<String, dynamic> body) async {
    var result = Either<Failure, LoginResponseModel>();
    try {
      var rawResponse = await dio.post(AppUrls.userLogin,
          data: body,
          options: Options(
            contentType: Headers.jsonContentType,
          ));
      var response = await rawResponse.getResult();
      if (response.isLeft()) {
        result.setLeft(response.getLeft());
      } else {
        var jsonData = json.decode(response.getRight());
        if (jsonData['status'] == true) {
          var responseModel =
              LoginResponseModel.fromJson(json.decode(response.getRight()));
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
  Future<Either<Failure, RegisterResponseModel>> register(
      Map<String, dynamic> body) async {
    var result = Either<Failure, RegisterResponseModel>();
    try {
      var rawResponse = await dio.post(AppUrls.userRegister,
          data: body,
          options: Options(
            contentType: Headers.jsonContentType,
          ));
      var response = await rawResponse.getResult();
      if (response.isLeft()) {
        result.setLeft(response.getLeft());
      } else {
        var jsonData = json.decode(response.getRight());
        if (jsonData['status'] == true) {
          var responseModel =
              RegisterResponseModel.fromJson(json.decode(response.getRight()));
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
  Future<Either<Failure, CheckUserResponseModel>> checkUser(
      Map<String, dynamic> body) async {
    var result = Either<Failure, CheckUserResponseModel>();
    try {
      var rawResponse = await dio.get(AppUrls.checkUser,
          data: body,
          options: Options(
            contentType: Headers.formUrlEncodedContentType,
          ));
      var response = await rawResponse.getResult();
      if (response.isLeft()) {
        result.setLeft(response.getLeft());
      } else {
        var jsonData = json.decode(response.getRight());
        if (jsonData['status'] == true) {
          var responseModel =
              CheckUserResponseModel.fromJson(json.decode(response.getRight()));
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
  Future<Either<Failure, CommonResponseModel>> updatePwd(
      Map<String, dynamic> body) async {
    var result = Either<Failure, CommonResponseModel>();
    try {
      var rawResponse = await dio.post(AppUrls.pwdUpdate,
          data: body,
          options: Options(
            contentType: Headers.jsonContentType,
          ));
      var response = await rawResponse.getResult();
      if (response.isLeft()) {
        result.setLeft(response.getLeft());
      } else {
        var jsonData = json.decode(response.getRight());
        if (jsonData['status'] == true) {
          var responseModel =
              CommonResponseModel.fromJson(json.decode(response.getRight()));
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

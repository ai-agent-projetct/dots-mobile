import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:provider/constants/app_urls.dart';
import 'package:provider/features/onboarding/data/datasource/onboarding_datasource.dart';
import 'package:provider/features/onboarding/data/models/category_response_model.dart';
import 'package:provider/features/onboarding/data/models/check_user_model.dart';
import 'package:provider/features/onboarding/data/models/common_response_model.dart';
import 'package:provider/features/onboarding/data/models/fileupload_responsemodel.dart';
import 'package:provider/features/onboarding/data/models/login_model.dart';
import 'package:provider/features/onboarding/data/models/register_model.dart';
import 'package:provider/features/onboarding/data/models/subcategory_model.dart';
import 'package:provider/utils/either.dart';
import 'package:provider/utils/network/error.dart';
import 'package:provider/utils/network/extension.dart';
import 'package:provider/utils/services/prefs.dart';

class OnboardingDatasourceImpl implements OnboardingDatasource {
  final Dio dio;

  OnboardingDatasourceImpl(this.dio);

  @override
  Future<Either<Failure, CategoryResponseModel>> getCategory() async {
    var result = Either<Failure, CategoryResponseModel>();

    try {
      var rawResponse = await dio.get(AppUrls.getCategory);
      var response = await rawResponse.getResult();
      if (response.isLeft()) {
        result.setLeft(response.getLeft());
      } else {
        var jsonData = json.decode(response.getRight());
        if (jsonData['status'] == true) {
          var responseModel = CategoryResponseModel.fromJson(
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
  Future<Either<Failure, SubCategoryResponseModel>> getSubCategory(
    String catId,
  ) async {
    var result = Either<Failure, SubCategoryResponseModel>();

    try {
      var rawResponse = await dio.get(
        AppUrls.getSubCategory,
        queryParameters: {'catId': catId},
      );
      var response = await rawResponse.getResult();
      if (response.isLeft()) {
        result.setLeft(response.getLeft());
      } else {
        var jsonData = json.decode(response.getRight());
        if (jsonData['status'] == true) {
          var responseModel = SubCategoryResponseModel.fromJson(
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
  Future<Either<Failure, LoginResponseModel>> login(
    Map<String, dynamic> body,
  ) async {
    var result = Either<Failure, LoginResponseModel>();
    try {
      var rawResponse = await dio.post(
        AppUrls.signIn,
        data: body,
        options: Options(contentType: Headers.jsonContentType),
      );
      var response = await rawResponse.getResult();
      if (response.isLeft()) {
        result.setLeft(response.getLeft());
      } else {
        var jsonData = json.decode(response.getRight());
        if (jsonData['status'] == true) {
          var responseModel = LoginResponseModel.fromJson(
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
  Future<Either<Failure, RegisterResponseModel>> register(
    Map<String, dynamic> body,
  ) async {
    var result = Either<Failure, RegisterResponseModel>();
    try {
      var rawResponse = await dio.post(
        AppUrls.register,
        data: body,
        options: Options(contentType: Headers.jsonContentType),
      );
      var response = await rawResponse.getResult();
      if (response.isLeft()) {
        result.setLeft(response.getLeft());
      } else {
        var jsonData = json.decode(response.getRight());
        if (jsonData['status'] == true) {
          var responseModel = RegisterResponseModel.fromJson(
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
  Future<Either<Failure, CheckUserResponseModel>> checkUser(
    Map<String, dynamic> body,
  ) async {
    var result = Either<Failure, CheckUserResponseModel>();
    try {
      var rawResponse = await dio.get(
        AppUrls.checkUser,
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      var response = await rawResponse.getResult();
      if (response.isLeft()) {
        result.setLeft(response.getLeft());
      } else {
        var jsonData = json.decode(response.getRight());
        if (jsonData['status'] == true) {
          var responseModel = CheckUserResponseModel.fromJson(
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
  Future<Either<Failure, CommonResponseModel>> updatePwd(
    Map<String, dynamic> body,
  ) async {
    var result = Either<Failure, CommonResponseModel>();
    try {
      var rawResponse = await dio.post(
        "",
        data: body,
        options: Options(contentType: Headers.jsonContentType),
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
}

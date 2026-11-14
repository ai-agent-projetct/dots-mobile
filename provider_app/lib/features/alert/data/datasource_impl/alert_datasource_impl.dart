import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:provider/constants/app_urls.dart';
import 'package:provider/features/alert/data/datasource/alert_datasource.dart';
import 'package:provider/features/alert/data/model/createoffer_respopnse_model.dart';
import 'package:provider/features/alert/data/model/getalloffers_model.dart';
import 'package:provider/features/alert/data/model/selectedservice_response_model.dart';
import 'package:provider/features/alert/data/model/updateoffer_model.dart';
import 'package:provider/utils/either.dart';
import 'package:provider/utils/network/error.dart';
import 'package:provider/utils/network/extension.dart';
import 'package:provider/utils/services/prefs.dart';

class AlertDatasourceImpl implements AlertDatasource {
  final Dio dio;

  AlertDatasourceImpl(this.dio);

  @override
  Future<Either<Failure, GetAllOffersResponseModel>> getAllOffers() async {
    var result = Either<Failure, GetAllOffersResponseModel>();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${Prefs().getString(Prefs.token)}',
    };
    try {
      var rawResponse = await dio.get(
        AppUrls.getAllOffers,
        options: Options(headers: headers),
      );
      var response = await rawResponse.getResult();
      if (response.isLeft()) {
        result.setLeft(response.getLeft());
      } else {
        var jsonData = json.decode(response.getRight());
        if (jsonData['status'] == true) {
          var responseModel = GetAllOffersResponseModel.fromJson(
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
  Future<Either<Failure, OfferUpdateResponseModel>> updateOffer(
    String offerId,
    Map<String, dynamic> body,
  ) async {
    var result = Either<Failure, OfferUpdateResponseModel>();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${Prefs().getString(Prefs.token)}',
    };
    try {
      var rawResponse = await dio.put(
        AppUrls.updateOffer(offerId),
        data: json.encode(body),
        options: Options(headers: headers),
      );
      var response = await rawResponse.getResult();
      if (response.isLeft()) {
        result.setLeft(response.getLeft());
      } else {
        var jsonData = json.decode(response.getRight());
        if (jsonData['status'] == true) {
          var responseModel = OfferUpdateResponseModel.fromJson(
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
  Future<Either<Failure, SelectedServicesResponseModel>>
  getProviderService() async {
    var result = Either<Failure, SelectedServicesResponseModel>();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${Prefs().getString(Prefs.token)}',
    };
    try {
      var rawResponse = await dio.get(
        AppUrls.selectedservice,
        options: Options(headers: headers),
      );
      var response = await rawResponse.getResult();
      if (response.isLeft()) {
        result.setLeft(response.getLeft());
      } else {
        var jsonData = json.decode(response.getRight());
        if (jsonData['status'] == true) {
          var responseModel = SelectedServicesResponseModel.fromJson(
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
  Future<Either<Failure, CreateOfferResponseModel>> createOffer(
    Map<String, dynamic> body,
  ) async {
    var result = Either<Failure, CreateOfferResponseModel>();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${Prefs().getString(Prefs.token)}',
    };
    try {
      var rawResponse = await dio.post(
        AppUrls.createOffers,
        data: json.encode(body),
        options: Options(headers: headers),
      );
      var response = await rawResponse.getResult();
      if (response.isLeft()) {
        result.setLeft(response.getLeft());
      } else {
        var jsonData = json.decode(response.getRight());
        if (jsonData['status'] == true) {
          var responseModel = CreateOfferResponseModel.fromJson(
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

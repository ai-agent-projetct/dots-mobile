import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:user/constants/app_urls.dart';
import 'package:user/features/offers/data/datasource/offers_datasorce.dart';
import 'package:user/features/offers/data/models/getalloffers_model.dart';
import 'package:user/features/trends/data/models/getall_trends_model.dart';
import 'package:user/network/error.dart';
import 'package:user/network/extension.dart';
import 'package:user/utils/either.dart';
import 'package:user/utils/services/prefs.dart';

class OffersDatasourceImpl implements OffersDatasource {
  final Dio dio;
  OffersDatasourceImpl(this.dio);

  @override
  Future<Either<Failure, GetAllOfferResponseModel>> getAllOffers(
    double lat,
    double lon,
  ) async {
    var result = Either<Failure, GetAllOfferResponseModel>();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${Prefs().getString(Prefs.token)}',
    };

    try {
      var rawResponse = await dio.get(
        AppUrls.getAllOffers(lat, lon),
        options: Options(headers: headers),
      );
      var response = await rawResponse.getResult();

      if (response.isLeft()) {
        result.setLeft(response.getLeft());
      } else {
        final rawJsonString = response.getRight();
        final jsonData = json.decode(rawJsonString);

        log("GetAllOfferResponseModel: $jsonData");

        if (jsonData['status'] == true) {
          final responseModel = GetAllOfferResponseModel.fromJson(jsonData);
          result.setRight(responseModel);
        } else {
          result.setLeft(CustomError((jsonData['message']) ?? UnknownError()));
        }
      }
    } on Exception catch (e) {
      if (e is DioException) {
        result.setLeft(e.getDioError());
      } else {
        result.setLeft(UnknownError());
      }
    }

    return result;
  }

  @override
  Future<Either<Failure, GetAllOfferResponseModel>> selectedOffersPost(
    Map<String, dynamic> body,
  ) async {
    var result = Either<Failure, GetAllOfferResponseModel>();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${Prefs().getString(Prefs.token)}',
    };
    try {
      var rawResponse = await dio.post(
        AppUrls.selectOffers,
        data: body,
        options: Options(headers: headers),
      );
      var response = await rawResponse.getResult();
      if (response.isLeft()) {
        result.setLeft(response.getLeft());
      } else {
        var jsonData = json.decode(response.getRight());
        if (jsonData['status']) {
          var responseModel = GetAllOfferResponseModel.fromJson(
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

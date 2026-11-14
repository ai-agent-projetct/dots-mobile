import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:user/constants/app_urls.dart';
import 'package:user/features/trends/data/datasource/trends_datasource.dart';
import 'package:user/features/trends/data/models/getall_trends_model.dart';
import 'package:user/features/trends/data/models/moretrends_response_model.dart';
import 'package:user/network/error.dart';
import 'package:user/network/extension.dart';
import 'package:user/utils/either.dart';
import 'package:user/utils/services/prefs.dart';

class TrendsDatasourceImpl implements TrendsDatasource {
  final Dio dio;
  TrendsDatasourceImpl(this.dio);

  @override
  Future<Either<Failure, GetAllTrendsResponseModel>> getAllTrends(
    double lat,
    double lon,
  ) async {
    var result = Either<Failure, GetAllTrendsResponseModel>();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${Prefs().getString(Prefs.token)}',
    };
    try {
      var rawResponse = await dio.get(
        AppUrls.getAllTrends(lat, lon),
        options: Options(headers: headers),
      );
      var response = await rawResponse.getResult();
      if (response.isLeft()) {
        result.setLeft(response.getLeft());
      } else {
        var jsonData = json.decode(response.getRight());
        if (jsonData['status'] == true) {
          var responseModel = GetAllTrendsResponseModel.fromJson(
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
  Future<Either<Failure, ProviderTrendsResponseModel>> moreTrends(
    String mediaId,
  ) async {
    var result = Either<Failure, ProviderTrendsResponseModel>();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${Prefs().getString(Prefs.token)}',
    };
    try {
      var rawResponse = await dio.get(
        AppUrls.moretrends(mediaId),
        options: Options(headers: headers),
      );
      var response = await rawResponse.getResult();
      if (response.isLeft()) {
        result.setLeft(response.getLeft());
      } else {
        var jsonData = json.decode(response.getRight());
        if (jsonData['status'] == true) {
          var responseModel = ProviderTrendsResponseModel.fromJson(
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

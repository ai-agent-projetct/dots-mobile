import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:provider/constants/app_urls.dart';
import 'package:provider/features/Trends/data/datasource/trends_datasource.dart';
import 'package:provider/features/Trends/data/model/createtrends_responsemodel.dart';
import 'package:provider/features/Trends/data/model/gettrends_responsemodel.dart';
import 'package:provider/features/Trends/data/model/trendsupdate_responsemodel.dart';
import 'package:provider/utils/either.dart';
import 'package:provider/utils/network/error.dart';
import 'package:provider/utils/network/extension.dart';
import 'package:provider/utils/services/prefs.dart';

class TrendsDatasourceImpl implements TrendsDatasource {
  final Dio dio;
  TrendsDatasourceImpl(this.dio);

  @override
  Future<Either<Failure, CreatetrendsResponsemodel>> createTrends(
    Map<String, dynamic> body,
  ) async {
    var result = Either<Failure, CreatetrendsResponsemodel>();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${Prefs().getString(Prefs.token)}',
    };
    try {
      var rawResponse = await dio.post(
        AppUrls.createTrends,
        data: body,
        options: Options(headers: headers),
      );
      var response = await rawResponse.getResult();
      if (response.isLeft()) {
        result.setLeft(response.getLeft());
      } else {
        var jsonData = json.decode(response.getRight());
        if (jsonData['status']) {
          var responseModel = CreatetrendsResponsemodel.fromJson(
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
  Future<Either<Failure, GetAllTrendsResponseModel>> getAllTrends() async {
    var result = Either<Failure, GetAllTrendsResponseModel>();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${Prefs().getString(Prefs.token)}',
    };
    final providerId = Prefs().getString(Prefs.userId);
    try {
      var rawResponse = await dio.get(
        AppUrls.getTrendsById(providerId!),
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
  Future<Either<Failure, TrendsupdateResponsemodel>> updateTrends(
    String mediaId,
    Map<String, dynamic> body,
  ) async {
    var result = Either<Failure, TrendsupdateResponsemodel>();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${Prefs().getString(Prefs.token)}',
    };
    try {
      var rawResponse = await dio.put(
        AppUrls.updateTrends(mediaId),
        data: body,
        options: Options(headers: headers),
      );
      var response = await rawResponse.getResult();
      if (response.isLeft()) {
        result.setLeft(response.getLeft());
      } else {
        var jsonData = json.decode(response.getRight());
        if (jsonData['status']) {
          var responseModel = TrendsupdateResponsemodel.fromJson(
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

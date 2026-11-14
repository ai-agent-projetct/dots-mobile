import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:user/constants/app_urls.dart';
import 'package:user/features/home/data/datasource/home_datasource.dart';
import 'package:user/features/home/data/models/dashboard_model.dart';
import 'package:user/features/home/data/models/poll_list_model.dart';
import 'package:user/features/home/data/models/poll_topics_model.dart';
import 'package:user/features/home/data/models/subactegorytlist_response_model.dart';
import 'package:user/features/home/data/models/trade_model.dart';
import 'package:user/features/offers/data/models/getalloffers_model.dart';
import 'package:user/features/onboarding/data/models/common_response_model.dart';
import 'package:user/network/error.dart';
import 'package:user/network/extension.dart';
import 'package:user/utils/either.dart';
import 'package:user/utils/services/prefs.dart';

class HomeDatasourceImpl implements HomeDatasource {
  final Dio dio;
  HomeDatasourceImpl(this.dio);

  @override
  Future<Either<Failure, CommonResponseModel>> deviceUpdate(
    Map<String, dynamic> body,
  ) async {
    debugPrint(".....Bearer ${Prefs().getString(Prefs.token)}....");
    var result = Either<Failure, CommonResponseModel>();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${Prefs().getString(Prefs.token)}',
    };
    try {
      var rawResponse = await dio.post(
        AppUrls.fcmUpdate,
        data: body,
        options: Options(headers: headers),
      );
      var response = await rawResponse.getResult();
      if (response.isLeft()) {
        result.setLeft(response.getLeft());
      } else {
        var jsonData = json.decode(response.getRight());
        if (jsonData['status']) {
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
  Future<Either<Failure, DashboardResponseModel>> getDashboard() async {
    var result = Either<Failure, DashboardResponseModel>();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${Prefs().getString(Prefs.token)}',
    };
    try {
      var rawResponse = await dio.get(
        AppUrls.dashboard,
        options: Options(headers: headers),
      );
      var response = await rawResponse.getResult();
      if (response.isLeft()) {
        result.setLeft(response.getLeft());
      } else {
        var jsonData = json.decode(response.getRight());
        if (jsonData['status'] == true) {
          var responseModel = DashboardResponseModel.fromJson(
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
  Future<Either<Failure, PollsListResponseModel>> getPollsList() async {
    var result = Either<Failure, PollsListResponseModel>();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${Prefs().getString(Prefs.token)}',
    };
    try {
      var rawResponse = await dio.get(
        AppUrls.pollsList,
        options: Options(headers: headers),
      );
      var response = await rawResponse.getResult();
      if (response.isLeft()) {
        result.setLeft(response.getLeft());
      } else {
        var jsonData = json.decode(response.getRight());
        if (jsonData['status'] == true) {
          var responseModel = PollsListResponseModel.fromJson(
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
  Future<Either<Failure, PollTopicsResponseModel>> getPollTopics() async {
    var result = Either<Failure, PollTopicsResponseModel>();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${Prefs().getString(Prefs.token)}',
    };
    try {
      var rawResponse = await dio.get(
        AppUrls.pollTopics,
        options: Options(headers: headers),
      );
      var response = await rawResponse.getResult();
      if (response.isLeft()) {
        result.setLeft(response.getLeft());
      } else {
        var jsonData = json.decode(response.getRight());
        if (jsonData['status'] == true) {
          var responseModel = PollTopicsResponseModel.fromJson(
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
  Future<Either<Failure, CommonResponseModel>> createPoll(
    Map<String, dynamic> body,
  ) async {
    var result = Either<Failure, CommonResponseModel>();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${Prefs().getString(Prefs.token)}',
    };
    try {
      var rawResponse = await dio.post(
        AppUrls.createPoll,
        data: body,
        options: Options(headers: headers),
      );
      var response = await rawResponse.getResult();
      if (response.isLeft()) {
        result.setLeft(response.getLeft());
      } else {
        var jsonData = json.decode(response.getRight());
        if (jsonData['status']) {
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
  Future<Either<Failure, CommonResponseModel>> votePoll(
    Map<String, dynamic> body,
  ) async {
    var result = Either<Failure, CommonResponseModel>();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${Prefs().getString(Prefs.token)}',
    };
    debugPrint(jsonEncode(body));
    try {
      var rawResponse = await dio.post(
        AppUrls.votePoll,
        data: body,
        options: Options(headers: headers),
      );
      var response = await rawResponse.getResult();
      if (response.isLeft()) {
        result.setLeft(response.getLeft());
      } else {
        var jsonData = json.decode(response.getRight());
        if (jsonData['status']) {
          var responseModel = CommonResponseModel.fromJson(
            json.decode(response.getRight()),
          );
          result.setRight(responseModel);
        } else {
          result.setLeft(CustomError((jsonData['message']) ?? UnknownError()));
        }
      }
    } on Exception catch (e) {
      debugPrint('$e');
      if (e is DioException) {
        result.setLeft(e.getDioError());
      }
    }
    return result;
  }

  @override
  Future<Either<Failure, CommonResponseModel>> createTrendPost(
    Map<String, dynamic> body,
  ) async {
    var result = Either<Failure, CommonResponseModel>();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${Prefs().getString(Prefs.token)}',
    };
    try {
      var rawResponse = await dio.post(
        AppUrls.createTrade,
        data: body,
        options: Options(headers: headers),
      );
      var response = await rawResponse.getResult();
      if (response.isLeft()) {
        result.setLeft(response.getLeft());
      } else {
        var jsonData = json.decode(response.getRight());
        if (jsonData['status']) {
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
  Future<Either<Failure, List<TradeData>>> getAllTrendPost() async {
    var result = Either<Failure, List<TradeData>>();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${Prefs().getString(Prefs.token)}',
    };
    try {
      final rawResponse = await dio.get(
        AppUrls.getAllTrades,
        options: Options(headers: headers),
      );
      final response = await rawResponse.getResult();
      if (response.isLeft()) {
        result.setLeft(response.getLeft());
      } else {
        final jsonData = json.decode(response.getRight());
        if (jsonData['status'] == true) {
          final List<TradeData> trades =
              (jsonData['data'] as List)
                  .map((e) => TradeData.fromJson(e))
                  .toList();
          result.setRight(trades);
        } else {
          result.setLeft(CustomError(jsonData['message']));
        }
      }
    } catch (e) {
      if (e is DioException) {
        result.setLeft(e.getDioError());
      } else {
        result.setLeft(CustomError("Unexpected error: $e"));
      }
    }
    return result;
  }

  @override
  Future<Either<Failure, List<TradeData>>> getTrendByUserId() async {
    var result = Either<Failure, List<TradeData>>();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${Prefs().getString(Prefs.token)}',
    };
    try {
      final String? userId = Prefs().getString(Prefs.userId);
      final rawResponse = await dio.get(
        // AppUrls.getTradeById(userId!),
        AppUrls.getAllTrades,
        options: Options(headers: headers),
      );
      final response = await rawResponse.getResult();
      if (response.isLeft()) {
        result.setLeft(response.getLeft());
      } else {
        final jsonData = json.decode(response.getRight());
        if (jsonData['status'] == true) {
          final List<TradeData> trades =
              (jsonData['data'] as List)
                  .map((e) => TradeData.fromJson(e))
                  .toList();
          result.setRight(trades);
        } else {
          result.setLeft(CustomError(jsonData['message']));
        }
      }
    } catch (e) {
      if (e is DioException) {
        result.setLeft(e.getDioError());
      } else {
        result.setLeft(CustomError("Unexpected error: $e"));
      }
    }
    return result;
  }

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
        AppUrls.getAllOffers(lat, lat),
        options: Options(headers: headers),
      );
      var response = await rawResponse.getResult();

      if (response.isLeft()) {
        result.setLeft(response.getLeft());
      } else {
        final rawJsonString = response.getRight();
        final jsonData = json.decode(rawJsonString);

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
  Future<Either<Failure, SubCategoryListResponseModel>>
  getsubCategoryList() async {
    var result = Either<Failure, SubCategoryListResponseModel>();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${Prefs().getString(Prefs.token)}',
    };

    try {
      var rawResponse = await dio.get(
        AppUrls.subcategorylist,
        options: Options(headers: headers),
      );
      var response = await rawResponse.getResult();

      if (response.isLeft()) {
        result.setLeft(response.getLeft());
      } else {
        final rawJsonString = response.getRight();
        final jsonData = json.decode(rawJsonString);

        if (jsonData['status'] == true) {
          final responseModel = SubCategoryListResponseModel.fromJson(jsonData);
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
}

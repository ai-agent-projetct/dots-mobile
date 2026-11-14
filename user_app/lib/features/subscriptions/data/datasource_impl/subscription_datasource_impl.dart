import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:user/constants/app_urls.dart';
import 'package:user/features/subscriptions/data/datasource/subscription_datasource.dart';
import 'package:user/features/subscriptions/data/model/createsubscription_response_model.dart';
import 'package:user/features/subscriptions/data/model/usersubscriptions_response_model.dart';
import 'package:user/network/error.dart';
import 'package:user/network/extension.dart';
import 'package:user/utils/either.dart';
import 'package:user/utils/services/prefs.dart';

class SubscriptionDatasourceImpl implements SubscriptionDatasource {
  final Dio dio;

  SubscriptionDatasourceImpl(this.dio);

  @override
  Future<Either<Failure, UserSubscriptionsResponseModel>>
  getUserSubscription() async {
    var result = Either<Failure, UserSubscriptionsResponseModel>();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${Prefs().getString(Prefs.token)}',
    };
    try {
      var rawResponse = await dio.get(
        AppUrls.getusersubscriptions,
        queryParameters: {'role_id': '1'},
        options: Options(headers: headers),
      );
      var response = await rawResponse.getResult();
      if (response.isLeft()) {
        result.setLeft(response.getLeft());
      } else {
        var jsonData = json.decode(response.getRight());
        if (jsonData['status'] == true) {
          var responseModel = UserSubscriptionsResponseModel.fromJson(
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
  Future<Either<Failure, CreateSubscriptionResponseModel>> createSubscription(
    String subscriptionId,
  ) async {
    var result = Either<Failure, CreateSubscriptionResponseModel>();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${Prefs().getString(Prefs.token)}',
    };
    try {
      var rawResponse = await dio.post(
        AppUrls.createusersubscriptions,
        data: {"subscription_id": subscriptionId},
        options: Options(headers: headers),
      );
      var response = await rawResponse.getResult();
      if (response.isLeft()) {
        result.setLeft(response.getLeft());
      } else {
        var jsonData = json.decode(response.getRight());
        if (jsonData['status'] == true) {
          var responseModel = CreateSubscriptionResponseModel.fromJson(
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

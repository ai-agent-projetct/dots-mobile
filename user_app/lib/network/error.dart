import 'package:equatable/equatable.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:user/constants/app_strings.dart';

abstract class Failure extends Equatable {
  @override
  List<Object> get props => [error, errorCode];

  String get error;

  int get errorCode;
}

class BadRequest extends Failure {
  @override
  String get error => translate(AppStringsKey.badRequest);

  @override
  int get errorCode => 400;
}

class Forbidden extends Failure {
  @override
  String get error => translate(AppStringsKey.forbidden);

  @override
  int get errorCode => 403;
}

class UrlNotFound extends Failure {
  @override
  String get error => translate(AppStringsKey.notFound);

  @override
  int get errorCode => 404;
}

class MethodNotAllowed extends Failure {
  @override
  String get error => translate(AppStringsKey.methodNotAllowed);

  @override
  int get errorCode => 405;
}

class InternalServerError extends Failure {
  @override
  String get error => translate(AppStringsKey.serverError);

  @override
  int get errorCode => 500;
}

class BadGateway extends Failure {
  @override
  String get error => translate(AppStringsKey.badGateway);

  @override
  int get errorCode => 502;
}

class ServerUnavailable extends Failure {
  @override
  String get error => translate(AppStringsKey.serviceUnavailable);

  @override
  int get errorCode => 503;
}

class GatewayTimeout extends Failure {
  @override
  String get error => translate(AppStringsKey.gatewayTimeout);

  @override
  int get errorCode => 504;
}

class UnknownError extends Failure {
  @override
  String get error => translate(AppStringsKey.somethingWentWrong);

  @override
  int get errorCode => 0;
}

class NoInternetConnection extends Failure {
  @override
  String get error => translate(AppStringsKey.noInternet);

  @override
  int get errorCode => 1;
}

class ApiReturnNull extends Failure {
  @override
  String get error => translate(AppStringsKey.apiReturnNullValue);

  @override
  int get errorCode => 2;
}

class CustomError extends Failure {
  final String? errorMessage;

  CustomError(this.errorMessage);

  @override
  String get error => errorMessage ?? "";

  @override
  int get errorCode => 5;
}

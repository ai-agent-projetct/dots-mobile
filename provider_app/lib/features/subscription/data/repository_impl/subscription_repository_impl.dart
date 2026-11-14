import 'package:provider/features/subscription/data/datasource/subscription_datasource.dart';
import 'package:provider/features/subscription/data/model/cashsubscription_model.dart';
import 'package:provider/features/subscription/data/model/createpayment_response_model.dart';
import 'package:provider/features/subscription/data/model/createsubscription_response_model.dart';
import 'package:provider/features/subscription/data/model/getsubscripions_response_model.dart';
import 'package:provider/features/subscription/data/model/subscription_response_model.dart';
import 'package:provider/features/subscription/data/model/updatepayment_response_model.dart';
import 'package:provider/features/subscription/domain/repository/subscription_repository.dart';
import 'package:provider/utils/either.dart';
import 'package:provider/utils/network/error.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final SubscriptionDatasource dataSource;

  SubscriptionRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, SubscriptionResponseModel>>
  getProviderSubscription() async {
    final result = Either<Failure, SubscriptionResponseModel>();
    final response = await dataSource.getProviderSubscription();

    if (response.isLeft()) {
      result.setLeft(response.getLeft());
    } else {
      result.setRight(response.getRight());
    }
    return result;
  }

  @override
  Future<Either<Failure, CreateSubscriptionResponseModel>> createSubscription(
    String subId,
  ) async {
    final result = Either<Failure, CreateSubscriptionResponseModel>();
    final response = await dataSource.createSubscription(subId);

    if (response.isLeft()) {
      result.setLeft(response.getLeft());
    } else {
      result.setRight(response.getRight());
    }
    return result;
  }

  @override
  Future<Either<Failure, CreatepaymentResponseModel>> createPayement(
    String subId,
  ) async {
    final result = Either<Failure, CreatepaymentResponseModel>();
    final response = await dataSource.createPayment(subId);

    if (response.isLeft()) {
      result.setLeft(response.getLeft());
    } else {
      result.setRight(response.getRight());
    }
    return result;
  }

  @override
  Future<Either<Failure, UpdatepaymentResponseModel>> updatePayement(
    String prosubid,
  ) async {
    final result = Either<Failure, UpdatepaymentResponseModel>();
    final response = await dataSource.updatePayment(prosubid);

    if (response.isLeft()) {
      result.setLeft(response.getLeft());
    } else {
      result.setRight(response.getRight());
    }
    return result;
  }

  @override
  Future<Either<Failure, CashSubscriptionResponseModel>> addCashSubscription(
    Map<String, dynamic> body,
  ) async {
    final result = Either<Failure, CashSubscriptionResponseModel>();
    final response = await dataSource.addCashSubscription(body);

    if (response.isLeft()) {
      result.setLeft(response.getLeft());
    } else {
      result.setRight(response.getRight());
    }
    return result;
  }

  @override
  Future<Either<Failure, GetSubscriptionsResponseModel>>
  getSubscriptions() async {
    final result = Either<Failure, GetSubscriptionsResponseModel>();
    final response = await dataSource.getSubscriptions();

    if (response.isLeft()) {
      result.setLeft(response.getLeft());
    } else {
      result.setRight(response.getRight());
    }
    return result;
  }
}

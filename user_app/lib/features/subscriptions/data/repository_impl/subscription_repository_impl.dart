import 'package:user/features/subscriptions/data/datasource/subscription_datasource.dart';
import 'package:user/features/subscriptions/data/model/createsubscription_response_model.dart';
import 'package:user/features/subscriptions/data/model/usersubscriptions_response_model.dart';
import 'package:user/features/subscriptions/domain/repository/subscription_repository.dart';
import 'package:user/network/error.dart';
import 'package:user/utils/either.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final SubscriptionDatasource dataSource;

  SubscriptionRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, UserSubscriptionsResponseModel>>
  getUserSubscription() async {
    final result = Either<Failure, UserSubscriptionsResponseModel>();
    final response = await dataSource.getUserSubscription();

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
}

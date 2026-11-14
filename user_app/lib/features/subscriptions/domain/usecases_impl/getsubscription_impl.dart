import 'package:user/features/subscriptions/data/model/usersubscriptions_response_model.dart'
    show UserSubscriptionsResponseModel;
import 'package:user/features/subscriptions/domain/repository/subscription_repository.dart';
import 'package:user/features/subscriptions/domain/usecases/getsubscriptions_usecase.dart';
import 'package:user/network/error.dart';
import 'package:user/utils/either.dart';

class GetUserSubscriptionsUsecaseImpl extends GetUserSubscriptionsUsecase {
  final SubscriptionRepository repository;
  GetUserSubscriptionsUsecaseImpl(this.repository);

  @override
  Future<Either<Failure, UserSubscriptionsResponseModel>>
  getUserSubscriptions() async {
    return await repository.getUserSubscription();
  }
}

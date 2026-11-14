import 'package:user/features/subscriptions/data/model/createsubscription_response_model.dart';
import 'package:user/features/subscriptions/domain/repository/subscription_repository.dart';
import 'package:user/features/subscriptions/domain/usecases/createsubscription_usecase.dart';
import 'package:user/network/error.dart';
import 'package:user/utils/either.dart';

class CreatesubscriptionUsecaseImpl extends CreatesubscriptionUsecase {
  final SubscriptionRepository repository;
  CreatesubscriptionUsecaseImpl(this.repository);

  @override
  Future<Either<Failure, CreateSubscriptionResponseModel>> createSubscription(
    String subId,
  ) async {
    return await repository.createSubscription(subId);
  }
}

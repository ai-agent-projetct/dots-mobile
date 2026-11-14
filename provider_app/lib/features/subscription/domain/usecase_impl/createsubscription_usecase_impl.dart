import 'package:provider/features/subscription/data/model/createsubscription_response_model.dart';
import 'package:provider/features/subscription/domain/repository/subscription_repository.dart';
import 'package:provider/features/subscription/domain/usecase/createsubscription_usecase.dart';
import 'package:provider/utils/either.dart';
import 'package:provider/utils/network/error.dart';

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

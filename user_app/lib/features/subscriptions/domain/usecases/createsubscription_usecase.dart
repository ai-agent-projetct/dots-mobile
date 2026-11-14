import 'package:user/features/subscriptions/data/model/createsubscription_response_model.dart';
import 'package:user/network/error.dart';
import 'package:user/utils/either.dart';

abstract class CreatesubscriptionUsecase {
  Future<Either<Failure, CreateSubscriptionResponseModel>> createSubscription(
    String subId,
  );
}

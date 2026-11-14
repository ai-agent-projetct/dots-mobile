import 'package:provider/features/subscription/data/model/createsubscription_response_model.dart';
import 'package:provider/utils/either.dart';
import 'package:provider/utils/network/error.dart';

abstract class CreatesubscriptionUsecase {
  Future<Either<Failure, CreateSubscriptionResponseModel>> createSubscription(
    String subId,
  );
}

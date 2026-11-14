import 'package:provider/features/subscription/data/model/getsubscripions_response_model.dart';
import 'package:provider/features/subscription/data/model/subscription_response_model.dart';
import 'package:provider/utils/either.dart';
import 'package:provider/utils/network/error.dart';

abstract class GetSubscriptionsUsecase {
  Future<Either<Failure, GetSubscriptionsResponseModel>> getSubscriptions();
}

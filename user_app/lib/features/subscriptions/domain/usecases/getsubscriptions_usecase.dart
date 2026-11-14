import 'package:user/features/subscriptions/data/model/usersubscriptions_response_model.dart';
import 'package:user/network/error.dart';
import 'package:user/utils/either.dart';

abstract class GetUserSubscriptionsUsecase {
  Future<Either<Failure, UserSubscriptionsResponseModel>>
  getUserSubscriptions();
}

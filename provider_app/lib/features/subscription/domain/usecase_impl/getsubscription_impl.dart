import 'package:provider/features/subscription/data/model/getsubscripions_response_model.dart';
import 'package:provider/features/subscription/data/model/subscription_response_model.dart';
import 'package:provider/features/subscription/domain/repository/subscription_repository.dart';
import 'package:provider/features/subscription/domain/usecase/getprovidersubscription_usecase.dart';
import 'package:provider/features/subscription/domain/usecase/getsubscriptions_usecase.dart';
import 'package:provider/utils/either.dart';
import 'package:provider/utils/network/error.dart';

class GetSubscriptionsUsecaseImpl extends GetSubscriptionsUsecase {
  final SubscriptionRepository repository;
  GetSubscriptionsUsecaseImpl(this.repository);

  @override
  Future<Either<Failure, GetSubscriptionsResponseModel>>
  getSubscriptions() async {
    return await repository.getSubscriptions();
  }
}

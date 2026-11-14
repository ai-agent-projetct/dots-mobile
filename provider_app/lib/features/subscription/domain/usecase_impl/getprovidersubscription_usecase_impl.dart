import 'package:provider/features/subscription/data/model/subscription_response_model.dart';
import 'package:provider/features/subscription/domain/repository/subscription_repository.dart';
import 'package:provider/features/subscription/domain/usecase/getprovidersubscription_usecase.dart';
import 'package:provider/utils/either.dart';
import 'package:provider/utils/network/error.dart';

class GetProviderSubscriUsecaseImpl extends GetProviderSubscriptionUsecase {
  final SubscriptionRepository repository;
  GetProviderSubscriUsecaseImpl(this.repository);

  @override
  Future<Either<Failure, SubscriptionResponseModel>>
  getProviderSubscription() async {
    return await repository.getProviderSubscription();
  }
}

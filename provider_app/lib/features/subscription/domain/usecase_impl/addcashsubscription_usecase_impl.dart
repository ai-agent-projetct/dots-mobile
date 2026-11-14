import 'package:provider/features/subscription/data/model/cashsubscription_model.dart';
import 'package:provider/features/subscription/data/model/createpayment_response_model.dart';
import 'package:provider/features/subscription/domain/repository/subscription_repository.dart';
import 'package:provider/features/subscription/domain/usecase/addcashsubscription_usecase.dart';
import 'package:provider/features/subscription/domain/usecase/createpayment_usecase.dart';
import 'package:provider/utils/either.dart';
import 'package:provider/utils/network/error.dart';

class AddcashsubscriptionUsecaseImpl extends AddcashsubscriptionUsecase {
  final SubscriptionRepository repository;
  AddcashsubscriptionUsecaseImpl(this.repository);

  @override
  Future<Either<Failure, CashSubscriptionResponseModel>> addCashSubscription(
    Map<String, dynamic> body,
  ) async {
    return await repository.addCashSubscription(body);
  }
}

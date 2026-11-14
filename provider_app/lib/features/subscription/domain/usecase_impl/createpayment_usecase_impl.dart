import 'package:provider/features/subscription/data/model/createpayment_response_model.dart';
import 'package:provider/features/subscription/domain/repository/subscription_repository.dart';
import 'package:provider/features/subscription/domain/usecase/createpayment_usecase.dart';
import 'package:provider/utils/either.dart';
import 'package:provider/utils/network/error.dart';

class CreatepaymentUsecaseImpl extends CreatepaymentUsecase {
  final SubscriptionRepository repository;
  CreatepaymentUsecaseImpl(this.repository);

  @override
  Future<Either<Failure, CreatepaymentResponseModel>> createPayment(
    String subId,
  ) async {
    return await repository.createPayement(subId);
  }
}

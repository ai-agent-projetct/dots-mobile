import 'package:provider/features/subscription/data/model/updatepayment_response_model.dart';
import 'package:provider/features/subscription/domain/repository/subscription_repository.dart';
import 'package:provider/features/subscription/domain/usecase/updatepayment_usecase.dart';
import 'package:provider/utils/either.dart';
import 'package:provider/utils/network/error.dart';

class UpdatepaymentUsecaseImpl extends UpdatepaymentUsecase {
  final SubscriptionRepository repository;
  UpdatepaymentUsecaseImpl(this.repository);

  @override
  Future<Either<Failure, UpdatepaymentResponseModel>> updatePayment(
    String proSubId,
  ) async {
    return await repository.updatePayement(proSubId);
  }
}

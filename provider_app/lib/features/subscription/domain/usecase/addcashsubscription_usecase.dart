import 'package:provider/features/subscription/data/model/cashsubscription_model.dart';
import 'package:provider/features/subscription/data/model/createpayment_response_model.dart';
import 'package:provider/features/subscription/data/model/createsubscription_response_model.dart';
import 'package:provider/utils/either.dart';
import 'package:provider/utils/network/error.dart';

abstract class AddcashsubscriptionUsecase {
  Future<Either<Failure, CashSubscriptionResponseModel>> addCashSubscription(
    Map<String, dynamic> body,
  );
}

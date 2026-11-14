import 'package:provider/features/subscription/data/model/createpayment_response_model.dart';
import 'package:provider/features/subscription/data/model/createsubscription_response_model.dart';
import 'package:provider/features/subscription/data/model/updatepayment_response_model.dart';
import 'package:provider/utils/either.dart';
import 'package:provider/utils/network/error.dart';

abstract class UpdatepaymentUsecase {
  Future<Either<Failure, UpdatepaymentResponseModel>> updatePayment(
    String proSubId,
  );
}

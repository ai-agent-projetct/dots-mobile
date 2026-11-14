import 'package:provider/features/subscription/data/model/cashsubscription_model.dart';
import 'package:provider/features/subscription/data/model/createpayment_response_model.dart';
import 'package:provider/features/subscription/data/model/createsubscription_response_model.dart';
import 'package:provider/features/subscription/data/model/getsubscripions_response_model.dart';
import 'package:provider/features/subscription/data/model/subscription_response_model.dart';
import 'package:provider/features/subscription/data/model/updatepayment_response_model.dart';
import 'package:provider/utils/either.dart';
import 'package:provider/utils/network/error.dart';

abstract class SubscriptionDatasource {
  Future<Either<Failure, SubscriptionResponseModel>> getProviderSubscription();
  Future<Either<Failure, CreatepaymentResponseModel>> createPayment(
    String subscriptionId,
  );
  Future<Either<Failure, UpdatepaymentResponseModel>> updatePayment(
    String prosubid,
  );
  Future<Either<Failure, CreateSubscriptionResponseModel>> createSubscription(
    String subscriptionId,
  );
  Future<Either<Failure, CashSubscriptionResponseModel>> addCashSubscription(
    Map<String, dynamic> body,
  );
  Future<Either<Failure, GetSubscriptionsResponseModel>> getSubscriptions();
}

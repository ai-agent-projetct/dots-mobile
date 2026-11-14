import 'package:provider/features/alert/data/model/updateoffer_model.dart';
import 'package:provider/utils/either.dart';
import 'package:provider/utils/network/error.dart';

abstract class UpdateofferUsecase {
  Future<Either<Failure, OfferUpdateResponseModel>> updateOffer(
    String offerId,
    Map<String, dynamic> body,
  );
}

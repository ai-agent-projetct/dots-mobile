import 'package:provider/features/alert/data/model/createoffer_respopnse_model.dart';
import 'package:provider/utils/either.dart';
import 'package:provider/utils/network/error.dart';

abstract class CreateOfferUsercase {
  Future<Either<Failure, CreateOfferResponseModel>> createOffer(
    Map<String, dynamic> body,
  );
}

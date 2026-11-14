import 'package:user/features/offers/data/models/getalloffers_model.dart';
import 'package:user/network/error.dart';
import 'package:user/utils/either.dart';

abstract class OffersDatasource {
  Future<Either<Failure, GetAllOfferResponseModel>> getAllOffers(
    double lat,
    double lon,
  );

  Future<Either<Failure, GetAllOfferResponseModel>> selectedOffersPost(
    Map<String, dynamic> body,
  );
}

import 'package:user/features/offers/data/models/getalloffers_model.dart';
import 'package:user/network/error.dart';
import 'package:user/utils/either.dart';

abstract class GetOffersUsecae {
  Future<Either<Failure, GetAllOfferResponseModel>> getAllOffers(
    double lat,
    double lon,
  );
}

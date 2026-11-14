import 'package:user/features/home/domain/usecase/getalloffers_usecase.dart';
import 'package:user/features/offers/data/models/getalloffers_model.dart';
import 'package:user/features/offers/domain/repository/offers_repositary.dart';
import 'package:user/network/error.dart';
import 'package:user/utils/either.dart';

class GetOffersImpl implements GetOffersUsecae {
  final OffersRepository _repository;
  GetOffersImpl(this._repository);
  @override
  Future<Either<Failure, GetAllOfferResponseModel>> getAllOffers(
    double lat,
    double lon,
  ) async {
    return await _repository.getAllOffers(lat, lon);
  }
}

import 'package:user/features/offers/data/models/getalloffers_model.dart';
import 'package:user/features/offers/domain/repository/offers_repositary.dart';
import 'package:user/features/offers/domain/usecases/getalloffers_usecase.dart';
import 'package:user/network/error.dart';
import 'package:user/utils/either.dart';

class GetAllOffersUsecaseImpl implements GetAllOffersUsecae {
  final OffersRepository _repository;
  GetAllOffersUsecaseImpl(this._repository);
  @override
  Future<Either<Failure, GetAllOfferResponseModel>> getAllOffers(
    double lat,
    double lon,
  ) async {
    return await _repository.getAllOffers(lat, lon);
  }
}

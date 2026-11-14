import 'package:user/features/offers/data/datasource/offers_datasorce.dart';
import 'package:user/features/offers/data/models/getalloffers_model.dart';
import 'package:user/features/offers/domain/repository/offers_repositary.dart';
import 'package:user/network/error.dart';
import 'package:user/utils/either.dart';

class OffersRepositoryImpl implements OffersRepository {
  final OffersDatasource _datasource;
  OffersRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, GetAllOfferResponseModel>> getAllOffers(
    double lat,
    double lon,
  ) async {
    var result = Either<Failure, GetAllOfferResponseModel>();
    var data = await _datasource.getAllOffers(lat, lon);
    if (data.isLeft()) {
      result.setLeft(data.getLeft());
    } else {
      result.setRight(data.getRight());
    }
    return result;
  }

  @override
  Future<Either<Failure, GetAllOfferResponseModel>> selectedOffersPost(
    Map<String, dynamic> body,
  ) async {
    var result = Either<Failure, GetAllOfferResponseModel>();
    var data = await _datasource.selectedOffersPost(body);
    if (data.isLeft()) {
      result.setLeft(data.getLeft());
    } else {
      result.setRight(data.getRight());
    }
    return result;
  }
}

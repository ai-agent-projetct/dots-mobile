import 'package:user/features/trends/data/datasource/trends_datasource.dart';
import 'package:user/features/trends/data/models/getall_trends_model.dart';
import 'package:user/features/trends/data/models/moretrends_response_model.dart';
import 'package:user/features/trends/domain/repository/trends_trpository.dart';
import 'package:user/network/error.dart';
import 'package:user/utils/either.dart';

class TrendsRepositoryImpl implements TrendsRepository {
  final TrendsDatasource _datasource;
  TrendsRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, GetAllTrendsResponseModel>> getAllTrends(
    double lat,
    double lon,
  ) async {
    var result = Either<Failure, GetAllTrendsResponseModel>();
    var data = await _datasource.getAllTrends(lat, lon);
    if (data.isLeft()) {
      result.setLeft(data.getLeft());
    } else {
      result.setRight(data.getRight());
    }
    return result;
  }

  @override
  Future<Either<Failure, ProviderTrendsResponseModel>> moreTrends(
    String mediaId,
  ) async {
    var result = Either<Failure, ProviderTrendsResponseModel>();
    var data = await _datasource.moreTrends(mediaId);
    if (data.isLeft()) {
      result.setLeft(data.getLeft());
    } else {
      result.setRight(data.getRight());
    }
    return result;
  }
}

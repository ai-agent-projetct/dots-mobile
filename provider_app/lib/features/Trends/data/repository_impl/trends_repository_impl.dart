import 'package:provider/features/Trends/data/datasource/trends_datasource.dart';
import 'package:provider/features/Trends/data/model/createtrends_responsemodel.dart';
import 'package:provider/features/Trends/data/model/gettrends_responsemodel.dart';
import 'package:provider/features/Trends/data/model/trendsupdate_responsemodel.dart';
import 'package:provider/features/Trends/domain/repository/trends_repositary.dart';
import 'package:provider/utils/either.dart';
import 'package:provider/utils/network/error.dart';

class TrendsRepositoryImpl implements TrendsRepository {
  final TrendsDatasource _datasource;
  TrendsRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, CreatetrendsResponsemodel>> createTrends(
    Map<String, dynamic> body,
  ) async {
    var result = Either<Failure, CreatetrendsResponsemodel>();
    var data = await _datasource.createTrends(body);
    if (data.isLeft()) {
      result.setLeft(data.getLeft());
    } else {
      result.setRight(data.getRight());
    }
    return result;
  }

  @override
  Future<Either<Failure, GetAllTrendsResponseModel>> getAllTrends() async {
    var result = Either<Failure, GetAllTrendsResponseModel>();
    var data = await _datasource.getAllTrends();
    if (data.isLeft()) {
      result.setLeft(data.getLeft());
    } else {
      result.setRight(data.getRight());
    }
    return result;
  }

  @override
  Future<Either<Failure, TrendsupdateResponsemodel>> updateTrends(
    String mediaId,
    Map<String, dynamic> body,
  ) async {
    var result = Either<Failure, TrendsupdateResponsemodel>();
    var data = await _datasource.updateTrends(mediaId, body);
    if (data.isLeft()) {
      result.setLeft(data.getLeft());
    } else {
      result.setRight(data.getRight());
    }
    return result;
  }
}

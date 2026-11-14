import 'package:provider/features/Trends/data/model/gettrends_responsemodel.dart';
import 'package:provider/utils/either.dart';
import 'package:provider/utils/network/error.dart';

abstract class GetAllTrendsUsecase {
  Future<Either<Failure, GetAllTrendsResponseModel>> getAllTrends();
}

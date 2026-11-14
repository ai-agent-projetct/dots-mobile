import 'package:provider/features/Trends/data/model/createtrends_responsemodel.dart';
import 'package:provider/features/Trends/data/model/gettrends_responsemodel.dart';
import 'package:provider/features/Trends/data/model/trendsupdate_responsemodel.dart';
import 'package:provider/features/onboarding/data/models/category_response_model.dart';
import 'package:provider/utils/either.dart';
import 'package:provider/utils/network/error.dart';

abstract class TrendsDatasource {
  Future<Either<Failure, CreatetrendsResponsemodel>> createTrends(
    Map<String, dynamic> body,
  );

  Future<Either<Failure, GetAllTrendsResponseModel>> getAllTrends();

  Future<Either<Failure, TrendsupdateResponsemodel>> updateTrends(
    String mediaId,
    Map<String, dynamic> body,
  );
}

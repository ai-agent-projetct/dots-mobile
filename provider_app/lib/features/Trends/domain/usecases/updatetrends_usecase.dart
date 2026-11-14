import 'package:provider/features/Trends/data/model/trendsupdate_responsemodel.dart';
import 'package:provider/utils/either.dart';
import 'package:provider/utils/network/error.dart';

abstract class UpdatetrendsUsecase {
  Future<Either<Failure, TrendsupdateResponsemodel>> updateTrends(
    String mediaId,
    Map<String, dynamic> body,
  );
}

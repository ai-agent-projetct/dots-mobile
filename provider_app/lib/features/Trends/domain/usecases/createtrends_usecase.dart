import 'package:provider/features/Trends/data/model/createtrends_responsemodel.dart';
import 'package:provider/utils/either.dart';
import 'package:provider/utils/network/error.dart';

abstract class CreateTrendsUsecase {
  Future<Either<Failure, CreatetrendsResponsemodel>> createTrends(
    Map<String, dynamic> body,
  );
}

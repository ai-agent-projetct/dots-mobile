import 'package:user/features/trends/data/models/getall_trends_model.dart';
import 'package:user/network/error.dart';
import 'package:user/utils/either.dart';

abstract class GetAllTrendsUsecae {
  Future<Either<Failure, GetAllTrendsResponseModel>> getAllTrends(
    double lat,
    double lon,
  );
}

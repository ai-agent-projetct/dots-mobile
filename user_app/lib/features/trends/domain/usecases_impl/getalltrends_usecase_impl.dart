import 'package:user/features/trends/data/models/getall_trends_model.dart';
import 'package:user/features/trends/domain/repository/trends_trpository.dart';
import 'package:user/features/trends/domain/usecases/getalltrends_usecase.dart';
import 'package:user/network/error.dart';
import 'package:user/utils/either.dart';

class GetAllTrendsUsecaseImpl implements GetAllTrendsUsecae {
  final TrendsRepository _repository;
  GetAllTrendsUsecaseImpl(this._repository);
  @override
  Future<Either<Failure, GetAllTrendsResponseModel>> getAllTrends(
    double lat,
    double lon,
  ) async {
    return await _repository.getAllTrends(lat, lon);
  }
}

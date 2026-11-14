import 'package:provider/features/Trends/data/model/gettrends_responsemodel.dart';
import 'package:provider/features/Trends/domain/repository/trends_repositary.dart';
import 'package:provider/features/Trends/domain/usecases/getalltrends_usecase.dart';
import 'package:provider/utils/either.dart';
import 'package:provider/utils/network/error.dart';

class GetAllTrendsUsecaseImpl implements GetAllTrendsUsecase {
  final TrendsRepository _repository;

  GetAllTrendsUsecaseImpl(this._repository);

  @override
  Future<Either<Failure, GetAllTrendsResponseModel>> getAllTrends() async {
    return await _repository.getAllTrends();
  }
}

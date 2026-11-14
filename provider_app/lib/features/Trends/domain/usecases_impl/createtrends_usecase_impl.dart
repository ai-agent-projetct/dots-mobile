import 'package:provider/features/Trends/data/model/createtrends_responsemodel.dart';
import 'package:provider/features/Trends/domain/repository/trends_repositary.dart';
import 'package:provider/features/Trends/domain/usecases/createtrends_usecase.dart';
import 'package:provider/utils/either.dart';
import 'package:provider/utils/network/error.dart';

class CreateTrendsUsecaseImpl implements CreateTrendsUsecase {
  final TrendsRepository _repository;

  CreateTrendsUsecaseImpl(this._repository);

  @override
  Future<Either<Failure, CreatetrendsResponsemodel>> createTrends(
    Map<String, dynamic> body,
  ) async {
    return await _repository.createTrends(body);
  }
}

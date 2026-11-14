import 'package:provider/features/Trends/data/model/createtrends_responsemodel.dart';
import 'package:provider/features/Trends/data/model/trendsupdate_responsemodel.dart';
import 'package:provider/features/Trends/domain/repository/trends_repositary.dart';
import 'package:provider/features/Trends/domain/usecases/createtrends_usecase.dart';
import 'package:provider/features/Trends/domain/usecases/updatetrends_usecase.dart';
import 'package:provider/utils/either.dart';
import 'package:provider/utils/network/error.dart';

class UpdatetrendsUsecaseImpl implements UpdatetrendsUsecase {
  final TrendsRepository _repository;

  UpdatetrendsUsecaseImpl(this._repository);

  @override
  Future<Either<Failure, TrendsupdateResponsemodel>> updateTrends(
    String mediaId,
    Map<String, dynamic> body,
  ) async {
    return await _repository.updateTrends(mediaId, body);
  }
}

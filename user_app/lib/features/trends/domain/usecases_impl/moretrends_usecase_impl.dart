import 'package:user/features/trends/data/models/getall_trends_model.dart';
import 'package:user/features/trends/data/models/moretrends_response_model.dart';
import 'package:user/features/trends/domain/repository/trends_trpository.dart';
import 'package:user/features/trends/domain/usecases/getalltrends_usecase.dart';
import 'package:user/features/trends/domain/usecases/moretrends_usecase.dart'
    show MoreTrendsUsecase;
import 'package:user/network/error.dart';
import 'package:user/utils/either.dart';

class MoreTrendsUsecasempl implements MoreTrendsUsecase {
  final TrendsRepository _repository;
  MoreTrendsUsecasempl(this._repository);

  @override
  Future<Either<Failure, ProviderTrendsResponseModel>> moreTrends(
    String mediaId,
  ) async {
    return await _repository.moreTrends(mediaId);
  }
}

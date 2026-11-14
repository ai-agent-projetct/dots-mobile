import 'package:user/features/home/domain/repository/home_repository.dart';
import 'package:user/features/home/domain/usecase/create_trendpost_usecase.dart';
import 'package:user/features/onboarding/data/models/common_response_model.dart';
import 'package:user/network/error.dart';
import 'package:user/utils/either.dart';

class CreateTrendpostUsecaeImpl implements CreateTrendPostUsecase {
  final HomeRepository _repository;

  CreateTrendpostUsecaeImpl(this._repository);

  @override
  Future<Either<Failure, CommonResponseModel>> createTreandPost(
    Map<String, dynamic> body,
  ) async {
    return await _repository.createTradePost(body);
  }
}

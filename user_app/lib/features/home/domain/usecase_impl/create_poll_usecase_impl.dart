import 'package:user/features/home/domain/repository/home_repository.dart';
import 'package:user/features/home/domain/usecase/create_poll_usecase.dart';
import 'package:user/features/onboarding/data/models/common_response_model.dart';
import 'package:user/network/error.dart';
import 'package:user/utils/either.dart';

class CreatePollUsecaseImpl implements CreatePollUsecase {
  final HomeRepository _repository;

  CreatePollUsecaseImpl(this._repository);

  @override
  Future<Either<Failure, CommonResponseModel>> createPoll(
      Map<String, dynamic> body) async {
    return await _repository.createPoll(body);
  }
}

import 'package:user/features/home/domain/repository/home_repository.dart';
import 'package:user/features/home/domain/usecase/vote_poll_usecase.dart';
import 'package:user/features/onboarding/data/models/common_response_model.dart';
import 'package:user/network/error.dart';
import 'package:user/utils/either.dart';

class VotePollUsecaseImpl implements VotePollUsecase {
  final HomeRepository _repository;
  VotePollUsecaseImpl(this._repository);

  @override
  Future<Either<Failure, CommonResponseModel>> votePoll(
      Map<String, dynamic> body) async {
    return await _repository.votePoll(body);
  }
}

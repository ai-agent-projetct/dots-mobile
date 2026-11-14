import 'package:user/features/home/data/models/poll_list_model.dart';
import 'package:user/features/home/domain/repository/home_repository.dart';
import 'package:user/features/home/domain/usecase/polls_list_usecase.dart';
import 'package:user/network/error.dart';
import 'package:user/utils/either.dart';

class PollsListUsecaseImpl implements PollsListUsecase {
  final HomeRepository _repository;
  PollsListUsecaseImpl(this._repository);

  @override
  Future<Either<Failure, PollsListResponseModel>> getPollsList() async {
    return await _repository.getPollsList();
  }
}

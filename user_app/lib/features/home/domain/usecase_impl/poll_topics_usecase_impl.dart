import 'package:user/features/home/data/models/poll_topics_model.dart';
import 'package:user/features/home/domain/repository/home_repository.dart';
import 'package:user/features/home/domain/usecase/poll_topics_usecase.dart';
import 'package:user/network/error.dart';
import 'package:user/utils/either.dart';

class PollTopicsUsecaseImpl implements PollTopicsUsecase {
  final HomeRepository _repository;

  PollTopicsUsecaseImpl(this._repository);

  @override
  Future<Either<Failure, PollTopicsResponseModel>> getPollTopics() async {
    return await _repository.getPollTopics();
  }
}

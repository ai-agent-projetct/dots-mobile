import 'package:user/features/home/data/models/poll_topics_model.dart';
import 'package:user/network/error.dart';
import 'package:user/utils/either.dart';

abstract class PollTopicsUsecase {
  Future<Either<Failure, PollTopicsResponseModel>> getPollTopics();
}

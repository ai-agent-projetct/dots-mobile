import 'package:user/features/home/data/models/poll_list_model.dart';
import 'package:user/network/error.dart';
import 'package:user/utils/either.dart';

abstract class PollsListUsecase {
  Future<Either<Failure, PollsListResponseModel>> getPollsList();
}

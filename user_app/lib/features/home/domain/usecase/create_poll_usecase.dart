import 'package:user/features/onboarding/data/models/common_response_model.dart';
import 'package:user/network/error.dart';
import 'package:user/utils/either.dart';

abstract class CreatePollUsecase {
  Future<Either<Failure, CommonResponseModel>> createPoll(
      Map<String, dynamic> body);
}

import 'package:user/features/onboarding/data/models/common_response_model.dart';
import 'package:user/network/error.dart';
import 'package:user/utils/either.dart';

abstract class UpdateProfileUsecase {
  Future<Either<Failure, CommonResponseModel>> profileUpdate(
      Map<dynamic, dynamic> body);
}

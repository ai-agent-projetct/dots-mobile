import 'package:user/features/onboarding/data/models/common_response_model.dart';
import 'package:user/network/error.dart';
import 'package:user/utils/either.dart';

abstract class PasswordUpdateUsecase {
  Future<Either<Failure, CommonResponseModel>> pwdUpdate(
      Map<String, dynamic> body);
}

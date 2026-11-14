import 'package:user/features/onboarding/data/models/check_user_model.dart';
import 'package:user/network/error.dart';
import 'package:user/utils/either.dart';

abstract class CheckUserUsecase {
  Future<Either<Failure, CheckUserResponseModel>> userCheck(
      Map<String, dynamic> body);
}

import 'package:user/features/onboarding/data/models/login_model.dart';
import 'package:user/network/error.dart';
import 'package:user/utils/either.dart';

abstract class LoginUsecase {
  Future<Either<Failure, LoginResponseModel>> userLogin(
      Map<String, dynamic> body);
}

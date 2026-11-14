import 'package:user/features/onboarding/data/models/register_model.dart';
import 'package:user/network/error.dart';
import 'package:user/utils/either.dart';

abstract class RegisterUsecase {
  Future<Either<Failure, RegisterResponseModel>> userRegister(
      Map<String, dynamic> body);
}

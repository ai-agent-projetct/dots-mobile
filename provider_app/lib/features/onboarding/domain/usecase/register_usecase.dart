import 'package:provider/features/onboarding/data/models/register_model.dart';
import 'package:provider/utils/either.dart';
import 'package:provider/utils/network/error.dart';

abstract class RegisterUsecase {
  Future<Either<Failure, RegisterResponseModel>> userRegister(
    Map<String, dynamic> body,
  );
}

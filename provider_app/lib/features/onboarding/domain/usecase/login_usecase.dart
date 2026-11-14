import 'package:provider/features/onboarding/data/models/login_model.dart';
import 'package:provider/utils/either.dart';
import 'package:provider/utils/network/error.dart';

abstract class LoginUsecase {
  Future<Either<Failure, LoginResponseModel>> userLogin(
    Map<String, dynamic> body,
  );
}

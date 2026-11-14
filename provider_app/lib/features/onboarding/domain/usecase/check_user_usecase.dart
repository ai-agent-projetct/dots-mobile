import 'package:provider/features/onboarding/data/models/check_user_model.dart';
import 'package:provider/utils/either.dart';
import 'package:provider/utils/network/error.dart';

abstract class CheckUserUsecase {
  Future<Either<Failure, CheckUserResponseModel>> userCheck(
    Map<String, dynamic> body,
  );
}

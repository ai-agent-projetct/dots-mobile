import 'package:user/features/onboarding/data/models/check_user_model.dart';
import 'package:user/features/onboarding/data/models/common_response_model.dart';
import 'package:user/features/onboarding/data/models/login_model.dart';
import 'package:user/features/onboarding/data/models/register_model.dart';
import 'package:user/utils/either.dart';
import '../../../../network/error.dart';
import '../../data/models/config_model.dart';

abstract class OnboardingRepository {
  Future<Either<Failure, ConfigModel>> getConfig();

  Future<Either<Failure, LoginResponseModel>> login(Map<String, dynamic> body);

  Future<Either<Failure, RegisterResponseModel>> register(
      Map<String, dynamic> body);

  Future<Either<Failure, CheckUserResponseModel>> checkUser(
      Map<String, dynamic> body);

  Future<Either<Failure, CommonResponseModel>> updatePwd(
      Map<String, dynamic> body);
}

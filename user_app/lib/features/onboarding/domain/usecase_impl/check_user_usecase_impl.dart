import 'package:user/features/onboarding/data/models/check_user_model.dart';
import 'package:user/features/onboarding/domain/repository/onboarding_repository.dart';
import 'package:user/features/onboarding/domain/usecase/check_user_usecase.dart';
import 'package:user/network/error.dart';
import 'package:user/utils/either.dart';

class CheckUserUsecaseImpl extends CheckUserUsecase {
  final OnboardingRepository repository;
  CheckUserUsecaseImpl(this.repository);
  @override
  Future<Either<Failure, CheckUserResponseModel>> userCheck(
      Map<String, dynamic> body) async {
    return await repository.checkUser(body);
  }
}

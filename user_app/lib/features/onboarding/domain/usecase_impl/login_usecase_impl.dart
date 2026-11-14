import 'package:user/features/onboarding/data/models/login_model.dart';
import 'package:user/features/onboarding/domain/repository/onboarding_repository.dart';
import 'package:user/features/onboarding/domain/usecase/login_usecase.dart';
import 'package:user/network/error.dart';
import 'package:user/utils/either.dart';

class LoginUsecaseImpl extends LoginUsecase {
  final OnboardingRepository repository;

  LoginUsecaseImpl(this.repository);

  @override
  Future<Either<Failure, LoginResponseModel>> userLogin(
      Map<String, dynamic> body) async {
    return await repository.login(body);
  }
}

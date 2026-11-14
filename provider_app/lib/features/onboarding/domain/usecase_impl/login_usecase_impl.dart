import 'package:provider/features/onboarding/data/models/login_model.dart';
import 'package:provider/features/onboarding/domain/repository/onboarding_repository.dart';
import 'package:provider/features/onboarding/domain/usecase/login_usecase.dart';
import 'package:provider/utils/either.dart';
import 'package:provider/utils/network/error.dart';

class LoginUsecaseImpl extends LoginUsecase {
  final OnboardingRepository repository;

  LoginUsecaseImpl(this.repository);

  @override
  Future<Either<Failure, LoginResponseModel>> userLogin(
    Map<String, dynamic> body,
  ) async {
    return await repository.login(body);
  }
}

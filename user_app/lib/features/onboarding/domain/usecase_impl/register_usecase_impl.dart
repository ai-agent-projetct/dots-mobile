import 'package:user/features/onboarding/data/models/register_model.dart';
import 'package:user/features/onboarding/domain/repository/onboarding_repository.dart';
import 'package:user/features/onboarding/domain/usecase/register_usecase.dart';
import 'package:user/network/error.dart';
import 'package:user/utils/either.dart';

class RegisterUsecaseImpl extends RegisterUsecase {
  final OnboardingRepository repository;

  RegisterUsecaseImpl(this.repository);

  @override
  Future<Either<Failure, RegisterResponseModel>> userRegister(
      Map<String, dynamic> body) async {
    return await repository.register(body);
  }
}

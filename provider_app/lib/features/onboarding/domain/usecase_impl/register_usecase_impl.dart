import 'package:provider/features/onboarding/data/models/register_model.dart';
import 'package:provider/features/onboarding/domain/repository/onboarding_repository.dart';
import 'package:provider/features/onboarding/domain/usecase/register_usecase.dart';
import 'package:provider/utils/either.dart';
import 'package:provider/utils/network/error.dart';

class RegisterUsecaseImpl extends RegisterUsecase {
  final OnboardingRepository repository;

  RegisterUsecaseImpl(this.repository);

  @override
  Future<Either<Failure, RegisterResponseModel>> userRegister(
    Map<String, dynamic> body,
  ) async {
    return await repository.register(body);
  }
}

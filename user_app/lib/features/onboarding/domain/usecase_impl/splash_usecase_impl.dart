import 'package:user/features/onboarding/data/models/config_model.dart';
import 'package:user/features/onboarding/domain/repository/onboarding_repository.dart';
import 'package:user/features/onboarding/domain/usecase/splash_usecase.dart';
import 'package:user/network/error.dart';
import 'package:user/utils/either.dart';

class SplashUsecaseImpl implements SplashUsecase {
  final OnboardingRepository repository;

  SplashUsecaseImpl(this.repository);

  @override
  Future<Either<Failure, ConfigModel>> getConfig() async {
    return await repository.getConfig();
  }
}

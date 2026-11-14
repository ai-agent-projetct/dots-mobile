import 'package:user/features/onboarding/data/models/config_model.dart';
import 'package:user/network/error.dart';
import 'package:user/utils/either.dart';

abstract class SplashUsecase {
  Future<Either<Failure, ConfigModel>> getConfig();
}

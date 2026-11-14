import 'package:provider/features/onboarding/data/models/common_response_model.dart';
import 'package:provider/features/onboarding/domain/repository/onboarding_repository.dart';
import 'package:provider/features/onboarding/domain/usecase/logout_usecase.dart';
import 'package:provider/utils/either.dart';
import 'package:provider/utils/network/error.dart';

class LogoutUsecaseImpl implements LogoutUsecase {
  final OnboardingRepository repository;
  LogoutUsecaseImpl(this.repository);
  @override
  Future<Either<Failure, CommonResponseModel>> signOut(
    Map<dynamic, dynamic> body,
  ) async {
    return await repository.logout(body);
  }
}

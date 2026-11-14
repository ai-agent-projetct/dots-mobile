import 'package:provider/features/onboarding/data/models/common_response_model.dart';
import 'package:provider/features/onboarding/domain/repository/onboarding_repository.dart';
import 'package:provider/features/onboarding/domain/usecase/password_update_usecase.dart';
import 'package:provider/utils/either.dart';
import 'package:provider/utils/network/error.dart';

class PasswordUpdateUsecaseImpl extends PasswordUpdateUsecase {
  final OnboardingRepository repository;
  PasswordUpdateUsecaseImpl(this.repository);
  @override
  Future<Either<Failure, CommonResponseModel>> pwdUpdate(
    Map<String, dynamic> body,
  ) async {
    return await repository.updatePwd(body);
  }
}

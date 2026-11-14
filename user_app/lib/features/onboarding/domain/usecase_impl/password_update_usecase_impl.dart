import 'package:user/features/onboarding/data/models/common_response_model.dart';
import 'package:user/features/onboarding/domain/repository/onboarding_repository.dart';
import 'package:user/features/onboarding/domain/usecase/password_update_usecase.dart';
import 'package:user/network/error.dart';
import 'package:user/utils/either.dart';

class PasswordUpdateUsecaseImpl extends PasswordUpdateUsecase {
  final OnboardingRepository repository;
  PasswordUpdateUsecaseImpl(this.repository);
  @override
  Future<Either<Failure, CommonResponseModel>> pwdUpdate(
      Map<String, dynamic> body) async {
    return await repository.updatePwd(body);
  }
}

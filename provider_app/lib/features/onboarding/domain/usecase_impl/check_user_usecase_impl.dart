import 'package:provider/features/onboarding/data/models/check_user_model.dart';
import 'package:provider/features/onboarding/domain/repository/onboarding_repository.dart';
import 'package:provider/features/onboarding/domain/usecase/check_user_usecase.dart';
import 'package:provider/utils/either.dart';
import 'package:provider/utils/network/error.dart';

class CheckUserUsecaseImpl extends CheckUserUsecase {
  final OnboardingRepository repository;
  CheckUserUsecaseImpl(this.repository);
  @override
  Future<Either<Failure, CheckUserResponseModel>> userCheck(
    Map<String, dynamic> body,
  ) async {
    return await repository.checkUser(body);
  }
}

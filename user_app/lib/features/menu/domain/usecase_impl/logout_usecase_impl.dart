import 'package:user/features/menu/domain/repository/profile_repository.dart';
import 'package:user/features/menu/domain/usecase/logout_usecase.dart';
import 'package:user/features/onboarding/data/models/common_response_model.dart';
import 'package:user/network/error.dart';
import 'package:user/utils/either.dart';

class LogoutUsecaseImpl implements LogoutUsecase {
  final ProfileRepository repository;
  LogoutUsecaseImpl(this.repository);
  @override
  Future<Either<Failure, CommonResponseModel>> signOut(
      Map<dynamic, dynamic> body) async {
    return await repository.logout(body);
  }
}

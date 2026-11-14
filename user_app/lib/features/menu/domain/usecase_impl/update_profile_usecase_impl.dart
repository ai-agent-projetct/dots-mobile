import 'package:user/features/menu/domain/repository/profile_repository.dart';
import 'package:user/features/menu/domain/usecase/update_profile_usecase.dart';
import 'package:user/features/onboarding/data/models/common_response_model.dart';
import 'package:user/network/error.dart';
import 'package:user/utils/either.dart';

class UpdateProfileUsecaseImpl implements UpdateProfileUsecase {
  final ProfileRepository repository;

  UpdateProfileUsecaseImpl(this.repository);

  @override
  Future<Either<Failure, CommonResponseModel>> profileUpdate(
      Map<dynamic, dynamic> body) async {
    return await repository.profileUpdate(body);
  }
}

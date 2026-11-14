import 'package:provider/features/onboarding/data/models/common_response_model.dart';
import 'package:provider/features/profile/domain/repository/profile_repository.dart';
import 'package:provider/features/profile/domain/usecase/updateprofile_usecase.dart';
import 'package:provider/utils/either.dart';
import 'package:provider/utils/network/error.dart';

class UpdateProfileUsecaseImpl implements UpdateProfileUsecase {
  final ProfileRepository repository;

  UpdateProfileUsecaseImpl(this.repository);

  @override
  Future<Either<Failure, CommonResponseModel>> profileUpdate(
    Map<dynamic, dynamic> body,
  ) async {
    return await repository.profileUpdate(body);
  }
}

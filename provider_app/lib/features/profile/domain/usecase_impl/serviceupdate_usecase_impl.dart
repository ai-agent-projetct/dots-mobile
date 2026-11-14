import 'package:provider/features/onboarding/data/models/common_response_model.dart';
import 'package:provider/features/profile/domain/repository/profile_repository.dart';
import 'package:provider/features/profile/domain/usecase/serviceupdate_usecase.dart';
import 'package:provider/features/profile/domain/usecase/updateprofile_usecase.dart';
import 'package:provider/utils/either.dart';
import 'package:provider/utils/network/error.dart';

class ServiceupdateUsecaseImpl implements ServiceUpdateUsecase {
  final ProfileRepository repository;

  ServiceupdateUsecaseImpl(this.repository);

  @override
  Future<Either<Failure, CommonResponseModel>> serviceUpdate(
    Map<dynamic, dynamic> body,
  ) async {
    return await repository.serviceUpdate(body);
  }
}

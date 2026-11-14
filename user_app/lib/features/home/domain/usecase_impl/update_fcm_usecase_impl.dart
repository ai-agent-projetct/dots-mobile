import 'package:user/features/home/domain/repository/home_repository.dart';
import 'package:user/features/home/domain/usecase/update_fcm_usecase.dart';
import 'package:user/features/onboarding/data/models/common_response_model.dart';
import 'package:user/network/error.dart';
import 'package:user/utils/either.dart';

class UpdateFcmUsecaseImpl implements UpdateFcmUsecase {
  final HomeRepository _repository;

  UpdateFcmUsecaseImpl(this._repository);

  @override
  Future<Either<Failure, CommonResponseModel>> deviceUpdate(
      Map<String, dynamic> body) async {
    return await _repository.deviceUpdate(body);
  }
}

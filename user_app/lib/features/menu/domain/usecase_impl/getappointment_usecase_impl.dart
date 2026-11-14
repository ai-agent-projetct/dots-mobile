import 'package:user/features/menu/data/models/appointment_response_model.dart';
import 'package:user/features/menu/domain/repository/profile_repository.dart';
import 'package:user/features/menu/domain/usecase/getappointment_usecase.dart';
import 'package:user/features/menu/domain/usecase/update_profile_usecase.dart';
import 'package:user/features/onboarding/data/models/common_response_model.dart';
import 'package:user/network/error.dart';
import 'package:user/utils/either.dart';

class GetAppointmentsUseacseImpl implements GetAppointmentsUseacse {
  final ProfileRepository repository;

  GetAppointmentsUseacseImpl(this.repository);

  @override
  Future<Either<Failure, GetAppointmentsResponseModel>> getAppointments({
    int page = 1,
    int limit = 10,
  }) async {
    return await repository.getAppointments(page: page, limit: limit);
  }
}

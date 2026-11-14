import 'package:provider/features/onboarding/data/models/common_response_model.dart';
import 'package:provider/features/profile/data/model/getappointments_response_model.dart';
import 'package:provider/features/profile/domain/repository/profile_repository.dart';
import 'package:provider/features/profile/domain/usecase/getappointments_usecase.dart';
import 'package:provider/features/profile/domain/usecase/updateprofile_usecase.dart';
import 'package:provider/utils/either.dart';
import 'package:provider/utils/network/error.dart';

class GetAppointmentsUsecaseImpl implements GetAppointmentUsecase {
  final ProfileRepository repository;

  GetAppointmentsUsecaseImpl(this.repository);

  @override
  Future<Either<Failure, GetAppointmentsResponseModel>>
  getAppointments() async {
    return await repository.getAppointments();
  }
}

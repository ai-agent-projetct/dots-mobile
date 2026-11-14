import 'package:provider/features/onboarding/data/models/common_response_model.dart';
import 'package:provider/features/profile/data/model/getappointments_response_model.dart';
import 'package:provider/utils/either.dart';
import 'package:provider/utils/network/error.dart';

abstract class GetAppointmentUsecase {
  Future<Either<Failure, GetAppointmentsResponseModel>> getAppointments();
}

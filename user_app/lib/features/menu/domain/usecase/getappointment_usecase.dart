import 'package:user/features/menu/data/models/appointment_response_model.dart';
import 'package:user/network/error.dart';
import 'package:user/utils/either.dart';

abstract class GetAppointmentsUseacse {
  Future<Either<Failure, GetAppointmentsResponseModel>> getAppointments({
    int page = 1,
    int limit = 10,
  });
}

import 'package:user/features/serviceProvider/data/models/appointment_response_model.dart';
import 'package:user/features/serviceProvider/data/models/providers_list_model.dart';
import 'package:user/network/error.dart';
import 'package:user/utils/either.dart';

abstract class AddAppointmentUsecase {
  Future<Either<Failure, AppointmentResponseModel>> addAppointment(
    Map<String, dynamic> body,
  );
}

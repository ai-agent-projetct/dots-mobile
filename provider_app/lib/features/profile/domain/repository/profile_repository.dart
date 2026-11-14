import 'package:provider/features/onboarding/data/models/common_response_model.dart';
import 'package:provider/features/profile/data/model/getappointments_response_model.dart';
import 'package:provider/utils/either.dart';
import 'package:provider/utils/network/error.dart';
import 'package:universal_io/io.dart';

abstract class ProfileRepository {
  Future<Either<Failure, CommonResponseModel>> profileUpdate(
    Map<dynamic, dynamic> body,
  );
  Future<Either<Failure, CommonResponseModel>> serviceUpdate(
    Map<dynamic, dynamic> body,
  );

  Future<Either<Failure, GetAppointmentsResponseModel>> getAppointments();
}

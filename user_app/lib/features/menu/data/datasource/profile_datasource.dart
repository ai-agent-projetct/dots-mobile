import 'package:universal_io/io.dart';
import 'package:user/features/menu/data/models/appointment_response_model.dart';
import 'package:user/features/menu/data/models/file_upload_model.dart';
import 'package:user/features/menu/data/models/notification_response_model.dart';
import 'package:user/features/menu/data/models/profile_model.dart';
import 'package:user/features/onboarding/data/models/common_response_model.dart';
import 'package:user/network/error.dart';
import 'package:user/utils/either.dart';

abstract class ProfileDatasource {
  Future<Either<Failure, ProfileResponseModel>> getProfileDetails();
  Future<Either<Failure, FileUploadResponseModel>> fileUpload(File file);
  Future<Either<Failure, CommonResponseModel>> profileUpdate(
    Map<dynamic, dynamic> body,
  );
  Future<Either<Failure, CommonResponseModel>> logout(
    Map<dynamic, dynamic> body,
  );

  Future<Either<Failure, GetAppointmentsResponseModel>> getAppointments({
    int page = 1,
    int limit = 10,
  });
  Future<Either<Failure, NotificationResponseModel>> getUserNotifications({
    int page = 1,
    int limit = 10,
  });
}

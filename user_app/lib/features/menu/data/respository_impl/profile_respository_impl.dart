import 'package:universal_io/io.dart';
import 'package:user/features/menu/data/datasource/profile_datasource.dart';
import 'package:user/features/menu/data/models/appointment_response_model.dart';
import 'package:user/features/menu/data/models/file_upload_model.dart';
import 'package:user/features/menu/data/models/notification_response_model.dart';
import 'package:user/features/menu/data/models/profile_model.dart';
import 'package:user/features/menu/domain/repository/profile_repository.dart';
import 'package:user/features/onboarding/data/models/common_response_model.dart';
import 'package:user/features/serviceProvider/data/models/appointment_response_model.dart';
import 'package:user/network/error.dart';
import 'package:user/utils/either.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileDatasource datasource;
  ProfileRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, ProfileResponseModel>> getProfileDetails() async {
    var result = Either<Failure, ProfileResponseModel>();
    var data = await datasource.getProfileDetails();
    if (data.isLeft()) {
      result.setLeft(data.getLeft());
    } else {
      result.setRight(data.getRight());
    }
    return result;
  }

  @override
  Future<Either<Failure, FileUploadResponseModel>> fileUpload(File file) async {
    return await datasource.fileUpload(file);
  }

  @override
  Future<Either<Failure, CommonResponseModel>> profileUpdate(
    Map<dynamic, dynamic> body,
  ) async {
    var result = Either<Failure, CommonResponseModel>();
    var data = await datasource.profileUpdate(body);
    if (data.isLeft()) {
      result.setLeft(data.getLeft());
    } else {
      result.setRight(data.getRight());
    }
    return result;
  }

  @override
  Future<Either<Failure, CommonResponseModel>> logout(
    Map<dynamic, dynamic> body,
  ) async {
    var result = Either<Failure, CommonResponseModel>();
    var data = await datasource.logout(body);
    if (data.isLeft()) {
      result.setLeft(data.getLeft());
    } else {
      result.setRight(data.getRight());
    }
    return result;
  }

  @override
  Future<Either<Failure, GetAppointmentsResponseModel>> getAppointments({
    int page = 1,
    int limit = 10,
  }) async {
    var result = Either<Failure, GetAppointmentsResponseModel>();
    var data = await datasource.getAppointments(page: page, limit: limit);
    if (data.isLeft()) {
      result.setLeft(data.getLeft());
    } else {
      result.setRight(data.getRight());
    }
    return result;
  }

  @override
  Future<Either<Failure, NotificationResponseModel>> getUserNotifications({
    int page = 1,
    int limit = 10,
  }) async {
    var result = Either<Failure, NotificationResponseModel>();
    var data = await datasource.getUserNotifications(page: page, limit: limit);
    if (data.isLeft()) {
      result.setLeft(data.getLeft());
    } else {
      result.setRight(data.getRight());
    }
    return result;
  }
}

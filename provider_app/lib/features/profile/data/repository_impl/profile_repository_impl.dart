import 'dart:developer';

import 'package:provider/features/onboarding/data/models/common_response_model.dart';
import 'package:provider/features/profile/data/datasource/profile_datasource.dart';
import 'package:provider/features/profile/data/model/getappointments_response_model.dart';
import 'package:provider/features/profile/domain/repository/profile_repository.dart';
import 'package:provider/utils/either.dart';
import 'package:provider/utils/network/error.dart';
import 'package:universal_io/io.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileDatasource datasource;
  ProfileRepositoryImpl(this.datasource);

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
  Future<Either<Failure, GetAppointmentsResponseModel>>
  getAppointments() async {
    var result = Either<Failure, GetAppointmentsResponseModel>();
    var data = await datasource.getAppointments();
    if (data.isLeft()) {
      result.setLeft(data.getLeft());
    } else {
      result.setRight(data.getRight());
    }
    return result;
  }

  @override
  Future<Either<Failure, CommonResponseModel>> serviceUpdate(
    Map<dynamic, dynamic> body,
  ) async {
    var result = Either<Failure, CommonResponseModel>();
    var data = await datasource.serviceUpdate(body);
    if (data.isLeft()) {
      result.setLeft(data.getLeft());
    } else {
      result.setRight(data.getRight());
    }
    return result;
  }
}

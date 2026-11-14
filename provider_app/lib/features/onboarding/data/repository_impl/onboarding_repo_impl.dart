import 'dart:io';

import 'package:provider/features/onboarding/data/datasource/onboarding_datasource.dart';
import 'package:provider/features/onboarding/data/models/category_response_model.dart';
import 'package:provider/features/onboarding/data/models/check_user_model.dart';
import 'package:provider/features/onboarding/data/models/common_response_model.dart';
import 'package:provider/features/onboarding/data/models/fileupload_responsemodel.dart';
import 'package:provider/features/onboarding/data/models/login_model.dart';
import 'package:provider/features/onboarding/data/models/register_model.dart';
import 'package:provider/features/onboarding/data/models/subcategory_model.dart';
import 'package:provider/features/onboarding/domain/repository/onboarding_repository.dart';
import 'package:provider/utils/either.dart';
import 'package:provider/utils/network/error.dart';

class OnboardingRepoImpl implements OnboardingRepository {
  final OnboardingDatasource dataSource;

  OnboardingRepoImpl(this.dataSource);

  @override
  Future<Either<Failure, CategoryResponseModel>> getCategory() async {
    final result = Either<Failure, CategoryResponseModel>();
    final response = await dataSource.getCategory();

    if (response.isLeft()) {
      result.setLeft(response.getLeft());
    } else {
      result.setRight(response.getRight());
    }
    return result;
  }

  @override
  Future<Either<Failure, SubCategoryResponseModel>> getSubCategory(
    String CatId,
  ) async {
    final result = Either<Failure, SubCategoryResponseModel>();
    final response = await dataSource.getSubCategory(CatId);

    if (response.isLeft()) {
      result.setLeft(response.getLeft());
    } else {
      result.setRight(response.getRight());
    }
    return result;
  }

  @override
  Future<Either<Failure, FileUploadResponseModel>> fileUpload(File file) async {
    return await dataSource.fileUpload(file);
  }

  @override
  Future<Either<Failure, LoginResponseModel>> login(
    Map<String, dynamic> body,
  ) async {
    var result = Either<Failure, LoginResponseModel>();
    var data = await dataSource.login(body);
    if (data.isLeft()) {
      result.setLeft(data.getLeft());
    } else {
      result.setRight(data.getRight());
    }
    return result;
  }

  @override
  Future<Either<Failure, RegisterResponseModel>> register(
    Map<String, dynamic> body,
  ) async {
    var result = Either<Failure, RegisterResponseModel>();
    var data = await dataSource.register(body);
    if (data.isLeft()) {
      result.setLeft(data.getLeft());
    } else {
      result.setRight(data.getRight());
    }
    return result;
  }

  @override
  Future<Either<Failure, CheckUserResponseModel>> checkUser(
    Map<String, dynamic> body,
  ) async {
    var result = Either<Failure, CheckUserResponseModel>();
    var data = await dataSource.checkUser(body);
    if (data.isLeft()) {
      result.setLeft(data.getLeft());
    } else {
      result.setRight(data.getRight());
    }
    return result;
  }

  @override
  Future<Either<Failure, CommonResponseModel>> updatePwd(
    Map<String, dynamic> body,
  ) async {
    var result = Either<Failure, CommonResponseModel>();
    var data = await dataSource.updatePwd(body);
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
    var data = await dataSource.logout(body);
    if (data.isLeft()) {
      result.setLeft(data.getLeft());
    } else {
      result.setRight(data.getRight());
    }
    return result;
  }
}

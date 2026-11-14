import 'package:user/features/onboarding/data/datasource/onboarding_datasource.dart';
import 'package:user/features/onboarding/data/models/check_user_model.dart';
import 'package:user/features/onboarding/data/models/common_response_model.dart';
import 'package:user/features/onboarding/data/models/config_model.dart';
import 'package:user/features/onboarding/data/models/login_model.dart';
import 'package:user/features/onboarding/data/models/register_model.dart';
import 'package:user/features/onboarding/domain/repository/onboarding_repository.dart';
import 'package:user/network/error.dart';
import 'package:user/utils/either.dart';

class OnboardingRepoImpl implements OnboardingRepository {
  final OnboardingDatasource dataSource;

  OnboardingRepoImpl(this.dataSource);

  @override
  Future<Either<Failure, ConfigModel>> getConfig() async {
    var result = Either<Failure, ConfigModel>();
    var data = await dataSource.getConfig();
    if (data.isLeft()) {
      result.setLeft(data.getLeft());
    } else {
      result.setRight(data.getRight());
    }
    return result;
  }

  @override
  Future<Either<Failure, LoginResponseModel>> login(
      Map<String, dynamic> body) async {
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
      Map<String, dynamic> body) async {
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
      Map<String, dynamic> body) async {
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
      Map<String, dynamic> body) async {
    var result = Either<Failure, CommonResponseModel>();
    var data = await dataSource.updatePwd(body);
    if (data.isLeft()) {
      result.setLeft(data.getLeft());
    } else {
      result.setRight(data.getRight());
    }
    return result;
  }
}

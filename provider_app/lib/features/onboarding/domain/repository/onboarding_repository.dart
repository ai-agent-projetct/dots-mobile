import 'dart:io';

import 'package:provider/features/onboarding/data/models/category_response_model.dart';
import 'package:provider/features/onboarding/data/models/check_user_model.dart';
import 'package:provider/features/onboarding/data/models/common_response_model.dart';
import 'package:provider/features/onboarding/data/models/fileupload_responsemodel.dart';
import 'package:provider/features/onboarding/data/models/login_model.dart';
import 'package:provider/features/onboarding/data/models/register_model.dart';
import 'package:provider/features/onboarding/data/models/subcategory_model.dart';
import 'package:provider/utils/either.dart';
import 'package:provider/utils/network/error.dart';

abstract class OnboardingRepository {
  Future<Either<Failure, CategoryResponseModel>> getCategory();
  Future<Either<Failure, SubCategoryResponseModel>> getSubCategory(
    String catId,
  );
  Future<Either<Failure, FileUploadResponseModel>> fileUpload(File file);

  Future<Either<Failure, LoginResponseModel>> login(Map<String, dynamic> body);

  Future<Either<Failure, RegisterResponseModel>> register(
    Map<String, dynamic> body,
  );

  Future<Either<Failure, CheckUserResponseModel>> checkUser(
    Map<String, dynamic> body,
  );

  Future<Either<Failure, CommonResponseModel>> updatePwd(
    Map<String, dynamic> body,
  );
  Future<Either<Failure, CommonResponseModel>> logout(
    Map<dynamic, dynamic> body,
  );
}

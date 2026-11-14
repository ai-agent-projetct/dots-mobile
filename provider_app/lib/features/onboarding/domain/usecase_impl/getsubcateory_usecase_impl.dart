import 'package:provider/features/onboarding/data/models/category_response_model.dart';
import 'package:provider/features/onboarding/data/models/subcategory_model.dart';
import 'package:provider/features/onboarding/domain/repository/onboarding_repository.dart';
import 'package:provider/features/onboarding/domain/usecase/getcategory_usecase.dart';
import 'package:provider/features/onboarding/domain/usecase/getsubcategory_usecase.dart';
import 'package:provider/utils/either.dart';
import 'package:provider/utils/network/error.dart';

class GetSubCategoryUsecaseImpl extends GetSubCategoryUsecase {
  final OnboardingRepository repository;
  GetSubCategoryUsecaseImpl(this.repository);

  @override
  Future<Either<Failure, SubCategoryResponseModel>> getSubCategory(
    String catId,
  ) async {
    return await repository.getSubCategory(catId);
  }
}

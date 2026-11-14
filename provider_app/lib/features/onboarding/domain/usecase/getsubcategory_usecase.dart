import 'package:provider/features/onboarding/data/models/category_response_model.dart';
import 'package:provider/features/onboarding/data/models/subcategory_model.dart';
import 'package:provider/utils/either.dart';
import 'package:provider/utils/network/error.dart';

abstract class GetSubCategoryUsecase {
  Future<Either<Failure, SubCategoryResponseModel>> getSubCategory(
    String catId,
  );
}

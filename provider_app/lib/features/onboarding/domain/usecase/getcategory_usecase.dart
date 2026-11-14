import 'package:provider/features/onboarding/data/models/category_response_model.dart';
import 'package:provider/utils/either.dart';
import 'package:provider/utils/network/error.dart';

abstract class GetcategoryUsecase {
  Future<Either<Failure, CategoryResponseModel>> getcategory();
}

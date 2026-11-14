import 'package:provider/features/onboarding/data/models/category_response_model.dart';
import 'package:provider/features/onboarding/domain/repository/onboarding_repository.dart';
import 'package:provider/features/onboarding/domain/usecase/getcategory_usecase.dart';
import 'package:provider/utils/either.dart';
import 'package:provider/utils/network/error.dart';

class GetcategoryUsecaseImpl extends GetcategoryUsecase {
  final OnboardingRepository repository;
  GetcategoryUsecaseImpl(this.repository);

  @override
  Future<Either<Failure, CategoryResponseModel>> getcategory() async {
    return await repository.getCategory();
  }
}

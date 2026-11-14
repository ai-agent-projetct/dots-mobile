import 'package:user/features/home/data/models/subactegorytlist_response_model.dart';
import 'package:user/features/home/domain/repository/home_repository.dart';
import 'package:user/features/home/domain/usecase/getsubcategorylist_usecase.dart';
import 'package:user/network/error.dart';
import 'package:user/utils/either.dart';

class GetsubcategorylistUscaseImpl implements GetsubcategorylistUsecase {
  final HomeRepository _repository;

  GetsubcategorylistUscaseImpl(this._repository);

  @override
  Future<Either<Failure, SubCategoryListResponseModel>>
  getSubCtaegoryList() async {
    return await _repository.getsubCategoryList();
  }
}

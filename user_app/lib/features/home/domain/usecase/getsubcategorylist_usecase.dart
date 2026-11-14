import 'package:user/features/home/data/models/subactegorytlist_response_model.dart';
import 'package:user/features/home/data/models/trade_model.dart';
import 'package:user/network/error.dart';
import 'package:user/utils/either.dart';

abstract class GetsubcategorylistUsecase {
  Future<Either<Failure, SubCategoryListResponseModel>> getSubCtaegoryList();
}

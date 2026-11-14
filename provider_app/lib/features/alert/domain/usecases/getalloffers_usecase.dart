import 'package:provider/features/alert/data/model/getalloffers_model.dart';
import 'package:provider/utils/either.dart';
import 'package:provider/utils/network/error.dart';

abstract class GetAllOffersUsecase {
  Future<Either<Failure, GetAllOffersResponseModel>> getAllOffers();
}

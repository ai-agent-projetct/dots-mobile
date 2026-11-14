import 'package:user/features/offers/data/models/getalloffers_model.dart';
import 'package:user/network/error.dart';
import 'package:user/utils/either.dart';

abstract class SelectedOffersPostUsecase {
  Future<Either<Failure, GetAllOfferResponseModel>> selectedOffersPost(
    Map<String, dynamic> body,
  );
}

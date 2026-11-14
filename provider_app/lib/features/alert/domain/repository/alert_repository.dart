import 'package:provider/features/alert/data/model/createoffer_respopnse_model.dart';
import 'package:provider/features/alert/data/model/getalloffers_model.dart';
import 'package:provider/features/alert/data/model/selectedservice_response_model.dart';
import 'package:provider/features/alert/data/model/updateoffer_model.dart';
import 'package:provider/utils/either.dart';
import 'package:provider/utils/network/error.dart';

abstract class AlertRepository {
  Future<Either<Failure, GetAllOffersResponseModel>> getAllOffers();
  Future<Either<Failure, CreateOfferResponseModel>> createOffer(
    Map<String, dynamic> body,
  );
  Future<Either<Failure, OfferUpdateResponseModel>> offerUpdate(
    String offerId,
    Map<String, dynamic> body,
  );
  Future<Either<Failure, SelectedServicesResponseModel>> getProviderServices();
}

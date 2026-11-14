import 'package:provider/features/alert/data/datasource/alert_datasource.dart';
import 'package:provider/features/alert/data/model/createoffer_respopnse_model.dart';
import 'package:provider/features/alert/data/model/getalloffers_model.dart';
import 'package:provider/features/alert/data/model/selectedservice_response_model.dart';
import 'package:provider/features/alert/data/model/updateoffer_model.dart';
import 'package:provider/features/alert/domain/repository/alert_repository.dart';
import 'package:provider/utils/either.dart';
import 'package:provider/utils/network/error.dart';

class AlertRepositoryImpl implements AlertRepository {
  final AlertDatasource dataSource;

  AlertRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, GetAllOffersResponseModel>> getAllOffers() async {
    final result = Either<Failure, GetAllOffersResponseModel>();
    final response = await dataSource.getAllOffers();

    if (response.isLeft()) {
      result.setLeft(response.getLeft());
    } else {
      result.setRight(response.getRight());
    }
    return result;
  }

  @override
  Future<Either<Failure, OfferUpdateResponseModel>> offerUpdate(
    String offerId,
    Map<String, dynamic> body,
  ) async {
    final result = Either<Failure, OfferUpdateResponseModel>();
    final response = await dataSource.updateOffer(offerId, body);

    if (response.isLeft()) {
      result.setLeft(response.getLeft());
    } else {
      result.setRight(response.getRight());
    }
    return result;
  }

  @override
  Future<Either<Failure, SelectedServicesResponseModel>>
  getProviderServices() async {
    final result = Either<Failure, SelectedServicesResponseModel>();
    final response = await dataSource.getProviderService();

    if (response.isLeft()) {
      result.setLeft(response.getLeft());
    } else {
      result.setRight(response.getRight());
    }
    return result;
  }

  @override
  Future<Either<Failure, CreateOfferResponseModel>> createOffer(
    Map<String, dynamic> body,
  ) async {
    final result = Either<Failure, CreateOfferResponseModel>();
    final response = await dataSource.createOffer(body);

    if (response.isLeft()) {
      result.setLeft(response.getLeft());
    } else {
      result.setRight(response.getRight());
    }
    return result;
  }
}

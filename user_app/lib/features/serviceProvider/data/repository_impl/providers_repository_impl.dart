import 'package:user/features/serviceProvider/data/datasource/provider_datasource.dart';
import 'package:user/features/serviceProvider/data/models/appointment_response_model.dart';
import 'package:user/features/serviceProvider/data/models/createreview_response_model.dart';
import 'package:user/features/serviceProvider/data/models/provider_details_model.dart';
import 'package:user/features/serviceProvider/data/models/providers_list_model.dart';
import 'package:user/features/serviceProvider/data/models/rating_response_model.dart';
import 'package:user/features/serviceProvider/domain/repository/providers_repository.dart';
import 'package:user/network/error.dart';
import 'package:user/utils/either.dart';

class ProvidersRepositoryImpl implements ProvidersRepository {
  final ProviderDatasource datasource;

  ProvidersRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, ProvidersListResponseModel>> getProvidersList(
    String lat,
    String lng,
    String subCatId,
  ) async {
    var result = Either<Failure, ProvidersListResponseModel>();
    var data = await datasource.getProvidersList(lat, lng, subCatId);
    if (data.isLeft()) {
      result.setLeft(data.getLeft());
    } else {
      result.setRight(data.getRight());
    }
    return result;
  }

  @override
  Future<Either<Failure, ProviderDetailsResponseModel>> getProviderDetails(
    String id,
  ) async {
    var result = Either<Failure, ProviderDetailsResponseModel>();
    var data = await datasource.getProviderDetails(id);
    if (data.isLeft()) {
      result.setLeft(data.getLeft());
    } else {
      result.setRight(data.getRight());
    }
    return result;
  }

  @override
  Future<Either<Failure, AppointmentResponseModel>> addAppointment(
    Map<String, dynamic> body,
  ) async {
    var result = Either<Failure, AppointmentResponseModel>();
    var data = await datasource.addAppointment(body);
    if (data.isLeft()) {
      result.setLeft(data.getLeft());
    } else {
      result.setRight(data.getRight());
    }
    return result;
  }

  @override
  Future<Either<Failure, CreateReviewResponseModel>> createReview(
    Map<String, dynamic> body,
  ) async {
    var result = Either<Failure, CreateReviewResponseModel>();
    var data = await datasource.createReview(body);
    if (data.isLeft()) {
      result.setLeft(data.getLeft());
    } else {
      result.setRight(data.getRight());
    }
    return result;
  }

  @override
  Future<Either<Failure, ProviderRatingsResponseModel>> getRatings(
    String providerId,
  ) async {
    var result = Either<Failure, ProviderRatingsResponseModel>();
    var data = await datasource.getRatings(providerId);
    if (data.isLeft()) {
      result.setLeft(data.getLeft());
    } else {
      result.setRight(data.getRight());
    }
    return result;
  }
}

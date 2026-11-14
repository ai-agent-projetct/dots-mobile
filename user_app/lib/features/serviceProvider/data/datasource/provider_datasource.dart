import 'package:user/features/serviceProvider/data/models/appointment_response_model.dart';
import 'package:user/features/serviceProvider/data/models/createreview_response_model.dart';
import 'package:user/features/serviceProvider/data/models/provider_details_model.dart';
import 'package:user/features/serviceProvider/data/models/providers_list_model.dart';
import 'package:user/features/serviceProvider/data/models/rating_response_model.dart';
import 'package:user/network/error.dart';
import 'package:user/utils/either.dart';

abstract class ProviderDatasource {
  Future<Either<Failure, ProvidersListResponseModel>> getProvidersList(
    String lat,
    String lng,
    String subCatId,
  );
  Future<Either<Failure, ProviderDetailsResponseModel>> getProviderDetails(
    String id,
  );
  Future<Either<Failure, AppointmentResponseModel>> addAppointment(
    Map<String, dynamic> body,
  );

  Future<Either<Failure, CreateReviewResponseModel>> createReview(
    Map<String, dynamic> body,
  );

  Future<Either<Failure, ProviderRatingsResponseModel>> getRatings(
    String providerId,
  );
}

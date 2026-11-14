import 'package:user/features/serviceProvider/data/models/appointment_response_model.dart';
import 'package:user/features/serviceProvider/data/models/createreview_response_model.dart';
import 'package:user/features/serviceProvider/data/models/providers_list_model.dart';
import 'package:user/features/serviceProvider/data/models/rating_response_model.dart';
import 'package:user/network/error.dart';
import 'package:user/utils/either.dart';

abstract class GetRatingsUsecase {
  Future<Either<Failure, ProviderRatingsResponseModel>> getRatings(
    String providerId,
  );
}

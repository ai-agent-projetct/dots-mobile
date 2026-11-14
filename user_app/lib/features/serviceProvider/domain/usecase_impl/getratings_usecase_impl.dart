import 'package:user/features/serviceProvider/data/models/appointment_response_model.dart';
import 'package:user/features/serviceProvider/data/models/providers_list_model.dart';
import 'package:user/features/serviceProvider/data/models/rating_response_model.dart';
import 'package:user/features/serviceProvider/domain/repository/providers_repository.dart';
import 'package:user/features/serviceProvider/domain/usecase/addappointmenty_usecase.dart';
import 'package:user/features/serviceProvider/domain/usecase/getratings_usecase.dart';
import 'package:user/features/serviceProvider/domain/usecase/providers_list_usecase.dart';
import 'package:user/network/error.dart';
import 'package:user/utils/either.dart';

class GetRatingsUsecaseImpl implements GetRatingsUsecase {
  final ProvidersRepository repository;

  GetRatingsUsecaseImpl(this.repository);

  @override
  Future<Either<Failure, ProviderRatingsResponseModel>> getRatings(
    String providerId,
  ) async {
    return await repository.getRatings(providerId);
  }
}

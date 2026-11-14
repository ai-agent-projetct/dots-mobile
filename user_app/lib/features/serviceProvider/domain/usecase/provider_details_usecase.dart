import 'package:user/features/serviceProvider/data/models/provider_details_model.dart';
import 'package:user/network/error.dart';
import 'package:user/utils/either.dart';

abstract class ProviderDetailsUsecase {
  Future<Either<Failure, ProviderDetailsResponseModel>> getProviderDetails(
      String id);
}

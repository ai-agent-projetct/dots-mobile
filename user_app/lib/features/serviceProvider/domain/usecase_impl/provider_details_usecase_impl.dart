import 'package:user/features/serviceProvider/data/models/provider_details_model.dart';
import 'package:user/features/serviceProvider/domain/repository/providers_repository.dart';
import 'package:user/features/serviceProvider/domain/usecase/provider_details_usecase.dart';
import 'package:user/network/error.dart';
import 'package:user/utils/either.dart';

class ProviderDetailsUsecaseImpl implements ProviderDetailsUsecase {
  final ProvidersRepository repository;

  ProviderDetailsUsecaseImpl(this.repository);

  @override
  Future<Either<Failure, ProviderDetailsResponseModel>> getProviderDetails(
      String id) async {
    return await repository.getProviderDetails(id);
  }
}

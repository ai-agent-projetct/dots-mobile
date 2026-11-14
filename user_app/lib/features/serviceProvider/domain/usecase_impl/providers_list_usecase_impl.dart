import 'package:user/features/serviceProvider/data/models/providers_list_model.dart';
import 'package:user/features/serviceProvider/domain/repository/providers_repository.dart';
import 'package:user/features/serviceProvider/domain/usecase/providers_list_usecase.dart';
import 'package:user/network/error.dart';
import 'package:user/utils/either.dart';

class ProvidersListUsecaseImpl implements ProvidersListUsecase {
  final ProvidersRepository repository;

  ProvidersListUsecaseImpl(this.repository);

  @override
  Future<Either<Failure, ProvidersListResponseModel>> getProvidersList(
      String lat, String lng, String subCatId) async {
    return await repository.getProvidersList(lat, lng, subCatId);
  }
}

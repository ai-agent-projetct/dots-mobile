import 'package:user/features/serviceProvider/data/models/providers_list_model.dart';
import 'package:user/network/error.dart';
import 'package:user/utils/either.dart';

abstract class ProvidersListUsecase {
  Future<Either<Failure, ProvidersListResponseModel>> getProvidersList(
      String lat, String lng, String subCatId);
}

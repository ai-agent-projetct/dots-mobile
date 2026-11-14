import 'package:provider/features/alert/data/model/selectedservice_response_model.dart';
import 'package:provider/utils/either.dart';
import 'package:provider/utils/network/error.dart';

abstract class GetProviderServicesUsecase {
  Future<Either<Failure, SelectedServicesResponseModel>> getProviderServices();
}

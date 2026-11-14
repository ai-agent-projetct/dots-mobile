import 'package:provider/features/alert/data/model/getalloffers_model.dart';
import 'package:provider/features/alert/data/model/selectedservice_response_model.dart';
import 'package:provider/features/alert/domain/repository/alert_repository.dart';
import 'package:provider/features/alert/domain/usecases/getalloffers_usecase.dart';
import 'package:provider/features/alert/domain/usecases/getproviderservices_usecase.dart';
import 'package:provider/utils/either.dart';
import 'package:provider/utils/network/error.dart';

class GetproviderservicesUsecaseImpl extends GetProviderServicesUsecase {
  final AlertRepository repository;
  GetproviderservicesUsecaseImpl(this.repository);

  @override
  Future<Either<Failure, SelectedServicesResponseModel>>
  getProviderServices() async {
    return await repository.getProviderServices();
  }
}

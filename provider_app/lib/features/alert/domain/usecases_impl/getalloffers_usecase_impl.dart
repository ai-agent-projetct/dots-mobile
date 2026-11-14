import 'package:provider/features/alert/data/model/getalloffers_model.dart';
import 'package:provider/features/alert/domain/repository/alert_repository.dart';
import 'package:provider/features/alert/domain/usecases/getalloffers_usecase.dart';
import 'package:provider/utils/either.dart';
import 'package:provider/utils/network/error.dart';

class GetAllOffersUsecaseImpl extends GetAllOffersUsecase {
  final AlertRepository repository;
  GetAllOffersUsecaseImpl(this.repository);

  @override
  Future<Either<Failure, GetAllOffersResponseModel>> getAllOffers() async {
    return await repository.getAllOffers();
  }
}

import 'package:provider/features/alert/data/model/updateoffer_model.dart';
import 'package:provider/features/alert/domain/repository/alert_repository.dart';
import 'package:provider/features/alert/domain/usecases/updateoffer_usecase.dart';
import 'package:provider/utils/either.dart';
import 'package:provider/utils/network/error.dart';

class UpdateofferUsecaseImpl extends UpdateofferUsecase {
  final AlertRepository repository;
  UpdateofferUsecaseImpl(this.repository);

  @override
  Future<Either<Failure, OfferUpdateResponseModel>> updateOffer(
    String offerId,
    Map<String, dynamic> body,
  ) async {
    return await repository.offerUpdate(offerId, body);
  }
}

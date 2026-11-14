import 'package:provider/features/alert/data/model/createoffer_respopnse_model.dart';
import 'package:provider/features/alert/domain/repository/alert_repository.dart';
import 'package:provider/features/alert/domain/usecases/createoffer_usercase.dart';
import 'package:provider/utils/either.dart';
import 'package:provider/utils/network/error.dart';

class CreateofferUsecaseImpl extends CreateOfferUsercase {
  final AlertRepository repository;
  CreateofferUsecaseImpl(this.repository);

  @override
  Future<Either<Failure, CreateOfferResponseModel>> createOffer(
    Map<String, dynamic> body,
  ) async {
    return await repository.createOffer(body);
  }
}

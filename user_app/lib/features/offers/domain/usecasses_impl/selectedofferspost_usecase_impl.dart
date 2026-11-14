import 'package:user/features/home/domain/repository/home_repository.dart';
import 'package:user/features/home/domain/usecase/create_poll_usecase.dart';
import 'package:user/features/offers/data/models/getalloffers_model.dart';
import 'package:user/features/offers/domain/repository/offers_repositary.dart';
import 'package:user/features/offers/domain/usecases/selectedofferspost_usecase.dart';
import 'package:user/features/onboarding/data/models/common_response_model.dart';
import 'package:user/network/error.dart';
import 'package:user/utils/either.dart';

class SelectedOffersPostUsecaseImpl implements SelectedOffersPostUsecase {
  final OffersRepository _repository;

  SelectedOffersPostUsecaseImpl(this._repository);

  @override
  Future<Either<Failure, GetAllOfferResponseModel>> selectedOffersPost(
    Map<String, dynamic> body,
  ) async {
    return await _repository.selectedOffersPost(body);
  }
}

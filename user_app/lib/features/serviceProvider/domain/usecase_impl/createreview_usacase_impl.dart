import 'package:user/features/serviceProvider/data/models/appointment_response_model.dart';
import 'package:user/features/serviceProvider/data/models/createreview_response_model.dart';
import 'package:user/features/serviceProvider/data/models/providers_list_model.dart';
import 'package:user/features/serviceProvider/domain/repository/providers_repository.dart';
import 'package:user/features/serviceProvider/domain/usecase/addappointmenty_usecase.dart';
import 'package:user/features/serviceProvider/domain/usecase/createreview_usecase.dart';
import 'package:user/features/serviceProvider/domain/usecase/providers_list_usecase.dart';
import 'package:user/network/error.dart';
import 'package:user/utils/either.dart';

class CreatReviewUsecaseImpl implements CreateReviewUsecase {
  final ProvidersRepository repository;

  CreatReviewUsecaseImpl(this.repository);

  @override
  Future<Either<Failure, CreateReviewResponseModel>> createReview(
    Map<String, dynamic> body,
  ) async {
    return await repository.createReview(body);
  }
}

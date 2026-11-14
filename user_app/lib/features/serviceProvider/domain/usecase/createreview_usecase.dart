import 'package:user/features/serviceProvider/data/models/appointment_response_model.dart';
import 'package:user/features/serviceProvider/data/models/createreview_response_model.dart';
import 'package:user/features/serviceProvider/data/models/providers_list_model.dart';
import 'package:user/network/error.dart';
import 'package:user/utils/either.dart';

abstract class CreateReviewUsecase {
  Future<Either<Failure, CreateReviewResponseModel>> createReview(
    Map<String, dynamic> body,
  );
}

import 'package:provider/features/onboarding/data/models/common_response_model.dart';
import 'package:provider/utils/either.dart';
import 'package:provider/utils/network/error.dart';

abstract class ServiceUpdateUsecase {
  Future<Either<Failure, CommonResponseModel>> serviceUpdate(
    Map<dynamic, dynamic> body,
  );
}

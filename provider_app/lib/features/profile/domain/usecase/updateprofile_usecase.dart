import 'package:provider/features/onboarding/data/models/common_response_model.dart';
import 'package:provider/utils/either.dart';
import 'package:provider/utils/network/error.dart';

abstract class UpdateProfileUsecase {
  Future<Either<Failure, CommonResponseModel>> profileUpdate(
    Map<dynamic, dynamic> body,
  );
}

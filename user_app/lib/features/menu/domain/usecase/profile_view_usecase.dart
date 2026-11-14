import 'package:user/features/menu/data/models/profile_model.dart';
import 'package:user/network/error.dart';
import 'package:user/utils/either.dart';

abstract class ProfileViewUsecase {
  Future<Either<Failure, ProfileResponseModel>> getProfileDetails();
}

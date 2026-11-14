import 'package:user/features/menu/data/models/profile_model.dart';
import 'package:user/features/menu/domain/repository/profile_repository.dart';
import 'package:user/features/menu/domain/usecase/profile_view_usecase.dart';
import 'package:user/network/error.dart';
import 'package:user/utils/either.dart';

class ProfileViewUsecaseImpl implements ProfileViewUsecase {
  final ProfileRepository repository;

  ProfileViewUsecaseImpl(this.repository);

  @override
  Future<Either<Failure, ProfileResponseModel>> getProfileDetails() async {
    return await repository.getProfileDetails();
  }
}

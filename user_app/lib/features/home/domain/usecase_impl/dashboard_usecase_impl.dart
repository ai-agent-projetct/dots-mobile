import 'package:user/features/home/data/models/dashboard_model.dart';
import 'package:user/features/home/domain/repository/home_repository.dart';
import 'package:user/features/home/domain/usecase/dashboard_usecase.dart';
import 'package:user/network/error.dart';
import 'package:user/utils/either.dart';

class DashboardUsecaseImpl implements DashboardUsecase {
  final HomeRepository _repository;
  DashboardUsecaseImpl(this._repository);

  @override
  Future<Either<Failure, DashboardResponseModel>> getDashboard() async {
    return await _repository.getDashboard();
  }
}

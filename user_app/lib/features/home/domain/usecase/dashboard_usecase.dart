import 'package:user/features/home/data/models/dashboard_model.dart';
import 'package:user/network/error.dart';
import 'package:user/utils/either.dart';

abstract class DashboardUsecase {
  Future<Either<Failure, DashboardResponseModel>> getDashboard();
}

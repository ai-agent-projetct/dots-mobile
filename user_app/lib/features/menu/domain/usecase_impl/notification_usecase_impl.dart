import 'package:user/features/menu/data/models/appointment_response_model.dart';
import 'package:user/features/menu/data/models/notification_response_model.dart';
import 'package:user/features/menu/domain/repository/profile_repository.dart';
import 'package:user/features/menu/domain/usecase/getappointment_usecase.dart';
import 'package:user/features/menu/domain/usecase/notification_usecase.dart';
import 'package:user/features/menu/domain/usecase/update_profile_usecase.dart';
import 'package:user/features/onboarding/data/models/common_response_model.dart';
import 'package:user/network/error.dart';
import 'package:user/utils/either.dart';

class GetUserNotificationsUseacseImpl implements GetUserNotificationUseacse {
  final ProfileRepository repository;

  GetUserNotificationsUseacseImpl(this.repository);

  @override
  Future<Either<Failure, NotificationResponseModel>> getUserNotifications({
    int page = 1,
    int limit = 10,
  }) async {
    return await repository.getUserNotifications(page: page, limit: limit);
  }
}

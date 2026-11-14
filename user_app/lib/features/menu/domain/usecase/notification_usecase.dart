import 'package:user/features/menu/data/models/appointment_response_model.dart';
import 'package:user/features/menu/data/models/notification_response_model.dart';
import 'package:user/network/error.dart';
import 'package:user/utils/either.dart';

abstract class GetUserNotificationUseacse {
  Future<Either<Failure, NotificationResponseModel>> getUserNotifications({
    int page = 1,
    int limit = 10,
  });
}

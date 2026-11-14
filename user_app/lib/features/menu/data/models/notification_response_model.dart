import 'package:intl/intl.dart';

class NotificationResponseModel {
  final bool status;
  final String message;
  final List<UserNotification> data;
  final Pagination? pagination;

  NotificationResponseModel({
    required this.status,
    required this.message,
    required this.data,
    this.pagination,
  });

  factory NotificationResponseModel.fromJson(Map<String, dynamic> json) {
    return NotificationResponseModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data:
          (json['data'] as List<dynamic>? ?? [])
              .map((item) => UserNotification.fromJson(item))
              .toList(),
      pagination:
          json['pagination'] != null
              ? Pagination.fromJson(json['pagination'])
              : null,
    );
  }
}

class Pagination {
  final int total;
  final int page;
  final int limit;
  final int pages;

  Pagination({
    required this.total,
    required this.page,
    required this.limit,
    required this.pages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      pages: json['pages'] ?? 1,
    );
  }
}

class UserNotification {
  final int id;
  final String notificationUuid;
  final String userType;
  final String? userUuid;
  final String title;
  final String message;
  final String? template;
  final String image;
  final int isActive;
  final String createdBy;
  final String? updatedBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserNotification({
    required this.id,
    required this.notificationUuid,
    required this.userType,
    this.userUuid,
    required this.title,
    required this.message,
    this.template,
    required this.image,
    required this.isActive,
    required this.createdBy,
    this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserNotification.fromJson(Map<String, dynamic> json) {
    return UserNotification(
      id: json['id'] ?? 0,
      notificationUuid: json['notification_uuid'] ?? '',
      userType: json['user_type'] ?? '',
      userUuid: json['user_uuid'],
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      template: json['template'],
      image: json['image'] ?? '',
      isActive: json['is_active'] ?? 0,
      createdBy: json['created_by'] ?? '',
      updatedBy: json['updated_by'],
      createdAt:
          DateTime.tryParse(json['created_at'] ?? '')?.toLocal() ??
          DateTime.now(),
      updatedAt:
          DateTime.tryParse(json['updated_at'] ?? '')?.toLocal() ??
          DateTime.now(),
    );
  }

  /// Example: 20, Jan, 2025 05:05 PM
  String get formattedDateTime {
    return DateFormat("dd, MMM, yyyy  hh:mm a").format(createdAt);
  }
}

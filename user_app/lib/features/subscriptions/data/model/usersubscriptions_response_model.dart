class UserSubscriptionsResponseModel {
  final bool status;
  final String message;
  final List<UserSubscriptionsData> data;

  UserSubscriptionsResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory UserSubscriptionsResponseModel.fromJson(Map<String, dynamic> json) {
    return UserSubscriptionsResponseModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => UserSubscriptionsData.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class UserSubscriptionsData {
  final int id;
  final String subscriptionId;
  final String userType;
  final int roleId;
  final String name;
  final int duration;
  final String amount;
  final int isActive;
  final String description;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserSubscriptionsData({
    required this.id,
    required this.subscriptionId,
    required this.userType,
    required this.roleId,
    required this.name,
    required this.duration,
    required this.amount,
    required this.isActive,
    required this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory UserSubscriptionsData.fromJson(Map<String, dynamic> json) {
    return UserSubscriptionsData(
      id: json['id'] ?? 0,
      subscriptionId: json['subscription_id'] ?? '',
      userType: json['user_type'] ?? '',
      roleId: json['role_id'] ?? 0,
      name: json['name'] ?? '',
      duration: json['duration'] ?? 0,
      amount: json['amount'] ?? '',
      isActive: json['is_active'] ?? 0,
      description: json['description'] ?? '',
      createdAt:
          json['created_at'] != null
              ? DateTime.tryParse(json['created_at'])
              : null,
      updatedAt:
          json['updated_at'] != null
              ? DateTime.tryParse(json['updated_at'])
              : null,
    );
  }
}

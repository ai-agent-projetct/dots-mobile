class CreateSubscriptionResponseModel {
  final bool status;
  final String message;
  final CreateSubscriptionData data;

  CreateSubscriptionResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CreateSubscriptionResponseModel.fromJson(Map<String, dynamic> json) {
    return CreateSubscriptionResponseModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: CreateSubscriptionData.fromJson(json['data'] ?? {}),
    );
  }
}

class CreateSubscriptionData {
  final String userSubId;
  final String subscriptionId;
  final String userId;
  final String subscriptionStatus;
  final bool isPaid;
  final DateTime startDate;
  final DateTime expiryDate;
  final int duration;
  final String createdBy;
  final String updatedBy;

  CreateSubscriptionData({
    required this.userSubId,
    required this.subscriptionId,
    required this.userId,
    required this.subscriptionStatus,
    required this.isPaid,
    required this.startDate,
    required this.expiryDate,
    required this.duration,
    required this.createdBy,
    required this.updatedBy,
  });

  factory CreateSubscriptionData.fromJson(Map<String, dynamic> json) {
    return CreateSubscriptionData(
      userSubId: json['user_sub_id'] ?? '',
      subscriptionId: json['subscription_id'] ?? '',
      userId: json['user_id'] ?? '',
      subscriptionStatus: json['subscription_status'] ?? '',
      isPaid: json['isPaid'] ?? false,
      startDate: DateTime.tryParse(json['start_date'] ?? '') ?? DateTime.now(),
      expiryDate:
          DateTime.tryParse(json['expiry_date'] ?? '') ?? DateTime.now(),
      duration: json['duration'] ?? 0,
      createdBy: json['created_by'] ?? '',
      updatedBy: json['updated_by'] ?? '',
    );
  }
}

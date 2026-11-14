class CreateSubscriptionResponseModel {
  final bool status;
  final String message;
  final SubscriptionData data;

  CreateSubscriptionResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CreateSubscriptionResponseModel.fromJson(Map<String, dynamic> json) {
    return CreateSubscriptionResponseModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: SubscriptionData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'message': message, 'data': data.toJson()};
  }
}

class SubscriptionData {
  final String proSubId;
  final String subscriptionId;
  final String providerId;
  final String subscriptionStatus;
  final bool isPaid;
  final DateTime startDate;
  final DateTime expiryDate;
  final int duration;
  final String createdBy;
  final String updatedBy;

  SubscriptionData({
    required this.proSubId,
    required this.subscriptionId,
    required this.providerId,
    required this.subscriptionStatus,
    required this.isPaid,
    required this.startDate,
    required this.expiryDate,
    required this.duration,
    required this.createdBy,
    required this.updatedBy,
  });

  factory SubscriptionData.fromJson(Map<String, dynamic> json) {
    return SubscriptionData(
      proSubId: json['pro_sub_id'] ?? '',
      subscriptionId: json['subscription_id'] ?? '',
      providerId: json['provider_id'] ?? '',
      subscriptionStatus: json['subscription_status'] ?? '',
      isPaid: json['isPaid'] ?? false,
      startDate: DateTime.parse(json['start_date']),
      expiryDate: DateTime.parse(json['expiry_date']),
      duration: json['duration'] ?? 0,
      createdBy: json['created_by'] ?? '',
      updatedBy: json['updated_by'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pro_sub_id': proSubId,
      'subscription_id': subscriptionId,
      'provider_id': providerId,
      'subscription_status': subscriptionStatus,
      'isPaid': isPaid,
      'start_date': startDate.toIso8601String(),
      'expiry_date': expiryDate.toIso8601String(),
      'duration': duration,
      'created_by': createdBy,
      'updated_by': updatedBy,
    };
  }
}

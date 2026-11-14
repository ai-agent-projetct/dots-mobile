class GetSubscriptionsResponseModel {
  final bool status;
  final String message;
  final List<GetSubscriptionData> data;

  GetSubscriptionsResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory GetSubscriptionsResponseModel.fromJson(Map<String, dynamic> json) {
    return GetSubscriptionsResponseModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data:
          (json['data'] as List<dynamic>?)
              ?.map(
                (e) => GetSubscriptionData.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }
}

class GetSubscriptionData {
  final int id;
  final String? proSubId;
  final String? subscriptionId;
  final String? providerId;
  final String? subscriptionStatus;
  final int isPaid;
  final String? startDate;
  final String? expiryDate;
  final int duration;
  final String? source;

  GetSubscriptionData({
    required this.id,
    this.proSubId,
    this.subscriptionId,
    this.providerId,
    this.subscriptionStatus,
    required this.isPaid,
    this.startDate,
    this.expiryDate,
    required this.duration,
    this.source,
  });

  factory GetSubscriptionData.fromJson(Map<String, dynamic> json) {
    return GetSubscriptionData(
      id: json['id'] ?? 0,
      proSubId: json['pro_sub_id'],
      subscriptionId: json['subscription_id'],
      providerId: json['provider_id'],
      subscriptionStatus: json['subscription_status'],
      isPaid: json['isPaid'] ?? 0,
      startDate: json['start_date'],
      expiryDate: json['expiry_date'],
      duration: json['duration'] ?? 0,
      source: json['source'],
    );
  }
}

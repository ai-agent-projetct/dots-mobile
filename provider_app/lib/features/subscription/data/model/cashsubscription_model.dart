class CashSubscriptionResponseModel {
  final bool status;
  final String message;
  final CashSubscriptionData data;

  CashSubscriptionResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CashSubscriptionResponseModel.fromJson(Map<String, dynamic> json) {
    return CashSubscriptionResponseModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: CashSubscriptionData.fromJson(json['data'] ?? {}),
    );
  }
}

class CashSubscriptionData {
  final String cashUuid;
  final SubscriptionDetails subscriptionDetails;
  final ExecutiveDetails executiveDetails;
  final String submissionDate;
  final String status;
  final int isApproved;
  final int isActive;
  final String createdBy;

  CashSubscriptionData({
    required this.cashUuid,
    required this.subscriptionDetails,
    required this.executiveDetails,
    required this.submissionDate,
    required this.status,
    required this.isApproved,
    required this.isActive,
    required this.createdBy,
  });

  factory CashSubscriptionData.fromJson(Map<String, dynamic> json) {
    return CashSubscriptionData(
      cashUuid: json['cash_uuid'] ?? '',
      subscriptionDetails: SubscriptionDetails.fromJson(
        json['subscription_details'] ?? {},
      ),
      executiveDetails: ExecutiveDetails.fromJson(
        json['executive_details'] ?? {},
      ),
      submissionDate: json['submission_date'] ?? '',
      status: json['status'] ?? '',
      isApproved: json['is_approved'] ?? 0,
      isActive: json['is_active'] ?? 0,
      createdBy: json['created_by'] ?? '',
    );
  }
}

class SubscriptionDetails {
  final String subscriptionId;
  final String subscriptionName;
  final String amount;
  final int duration;

  SubscriptionDetails({
    required this.subscriptionId,
    required this.subscriptionName,
    required this.amount,
    required this.duration,
  });

  factory SubscriptionDetails.fromJson(Map<String, dynamic> json) {
    return SubscriptionDetails(
      subscriptionId: json['subscription_id'] ?? '',
      subscriptionName: json['subscription_name'] ?? '',
      amount: json['amount'] ?? '0.0',
      duration: json['duration'] ?? 0,
    );
  }
}

class ExecutiveDetails {
  final String executiveUuid;
  final String executiveName;

  ExecutiveDetails({required this.executiveUuid, required this.executiveName});

  factory ExecutiveDetails.fromJson(Map<String, dynamic> json) {
    return ExecutiveDetails(
      executiveUuid: json['executive_uuid'] ?? '',
      executiveName: json['executive_name'] ?? '',
    );
  }
}

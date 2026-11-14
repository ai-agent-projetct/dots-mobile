class CreatepaymentResponseModel {
  final bool status;
  final String message;
  final PaymentData data;

  CreatepaymentResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CreatepaymentResponseModel.fromJson(Map<String, dynamic> json) {
    return CreatepaymentResponseModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: PaymentData.fromJson(json['data'] ?? {}),
    );
  }
}

class PaymentData {
  final String paymentId;
  final String receipt;
  final int amount;
  final String currency;
  final ProviderDetails providerDetails;

  PaymentData({
    required this.paymentId,
    required this.receipt,
    required this.amount,
    required this.currency,
    required this.providerDetails,
  });

  factory PaymentData.fromJson(Map<String, dynamic> json) {
    return PaymentData(
      paymentId: json['payment_id'] ?? '',
      receipt: json['receipt'] ?? '',
      amount: json['amount'] ?? 0,
      currency: json['currency'] ?? '',
      providerDetails: ProviderDetails.fromJson(json['provider_details'] ?? {}),
    );
  }
}

class ProviderDetails {
  final String providerId;
  final String firstName;
  final String lastName;

  ProviderDetails({
    required this.providerId,
    required this.firstName,
    required this.lastName,
  });

  factory ProviderDetails.fromJson(Map<String, dynamic> json) {
    return ProviderDetails(
      providerId: json['provider_id'] ?? '',
      firstName: json['Firstname'] ?? '',
      lastName: json['lastname'] ?? '',
    );
  }
}

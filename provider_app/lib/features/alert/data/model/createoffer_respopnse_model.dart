class CreateOfferResponseModel {
  final bool status;
  final String message;
  final OfferData data;

  CreateOfferResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CreateOfferResponseModel.fromJson(Map<String, dynamic> json) {
    return CreateOfferResponseModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: OfferData.fromJson(json['data']),
    );
  }
}

class OfferData {
  final String offerId;

  OfferData({required this.offerId});

  factory OfferData.fromJson(Map<String, dynamic> json) {
    return OfferData(offerId: json['offer_id'] ?? '');
  }
}

class OfferUpdateResponseModel {
  final bool status;
  final String message;

  OfferUpdateResponseModel({required this.status, required this.message});

  factory OfferUpdateResponseModel.fromJson(Map<String, dynamic> json) {
    return OfferUpdateResponseModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
    );
  }
}

class UpdatepaymentResponseModel {
  final bool status;
  final String message;

  UpdatepaymentResponseModel({required this.status, required this.message});

  factory UpdatepaymentResponseModel.fromJson(Map<String, dynamic> json) {
    return UpdatepaymentResponseModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'message': message};
  }
}

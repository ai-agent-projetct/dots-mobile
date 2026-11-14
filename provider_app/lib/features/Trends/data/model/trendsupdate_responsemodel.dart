class TrendsupdateResponsemodel {
  final bool status;
  final String message;

  TrendsupdateResponsemodel({required this.status, required this.message});

  // Factory method to create from JSON
  factory TrendsupdateResponsemodel.fromJson(Map<String, dynamic> json) {
    return TrendsupdateResponsemodel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
    );
  }
}

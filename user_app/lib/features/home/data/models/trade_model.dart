class TradePostRequest {
  final String uploadImage;
  final String description;

  TradePostRequest({required this.uploadImage, required this.description});

  Map<String, dynamic> toJson() {
    return {"upload_image": uploadImage, "description": description};
  }
}

class TradePostResponse {
  final bool status;
  final String message;
  final TradeData? data;

  TradePostResponse({required this.status, required this.message, this.data});

  factory TradePostResponse.fromJson(Map<String, dynamic> json) {
    return TradePostResponse(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null ? TradeData.fromJson(json['data']) : null,
    );
  }
}

class TradeData {
  final String? tradeId;
  final String? userId;
  final String? userName;
  final String? uploadImage;
  final String? description;
  final String? createdBy;
  final int? isActive;
  final String? createdAt;
  final String? updatedAt;

  TradeData({
    this.tradeId,
    this.userId,
    this.userName,
    this.uploadImage,
    this.description,
    this.createdBy,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory TradeData.fromJson(Map<String, dynamic> json) {
    return TradeData(
      tradeId: json['trade_id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      userName: json['user_name'] as String? ?? 'User',

      uploadImage: json['upload_image'] as String? ?? '',
      description: json['description'] as String? ?? '',
      createdBy: json['created_by'] as String?,
      isActive: json['is_active'] as int?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    "trade_id": tradeId,
    "user_id": userId,
    "upload_image": uploadImage,
    "description": description,
    "created_by": createdBy,
    "is_active": isActive,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}

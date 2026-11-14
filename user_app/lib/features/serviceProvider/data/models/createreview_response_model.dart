class CreateReviewResponseModel {
  final bool status;
  final String message;
  final CreatedReviewData? data;

  CreateReviewResponseModel({
    required this.status,
    required this.message,
    this.data,
  });

  factory CreateReviewResponseModel.fromJson(Map<String, dynamic> json) {
    return CreateReviewResponseModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data:
          json['data'] != null
              ? CreatedReviewData.fromJson(json['data'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'message': message, 'data': data?.toJson()};
  }
}

class CreatedReviewData {
  final int id;
  final String reviewId;
  final String providerId;
  final String userId;
  final double rating;
  final String reviews;
  final String createdBy;
  final String updatedBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  CreatedReviewData({
    required this.id,
    required this.reviewId,
    required this.providerId,
    required this.userId,
    required this.rating,
    required this.reviews,
    required this.createdBy,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CreatedReviewData.fromJson(Map<String, dynamic> json) {
    return CreatedReviewData(
      id: json['id'] ?? 0,
      reviewId: json['review_id'] ?? '',
      providerId: json['provider_id'] ?? '',
      userId: json['user_id'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      reviews: json['reviews'] ?? '',
      createdBy: json['created_by'] ?? '',
      updatedBy: json['updated_by'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'review_id': reviewId,
      'provider_id': providerId,
      'user_id': userId,
      'rating': rating,
      'reviews': reviews,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

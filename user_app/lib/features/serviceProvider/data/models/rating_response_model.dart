class ProviderRatingsResponseModel {
  final bool status;
  final String message;
  final RatingData data;

  ProviderRatingsResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ProviderRatingsResponseModel.fromJson(Map<String, dynamic> json) {
    return ProviderRatingsResponseModel(
      status: json['status'] as bool,
      message: json['message'] as String,
      data: RatingData.fromJson(json['data'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class RatingData {
  final double? averageRating;
  final int totalReviews;
  final List<UserReview> reviews;

  RatingData({
    this.averageRating,
    required this.totalReviews,
    required this.reviews,
  });

  factory RatingData.fromJson(Map<String, dynamic> json) {
    double? parseDouble(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value.toDouble();
      if (value is double) return value;
      return double.tryParse(value.toString());
    }

    int parseInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is double) return value.toInt();
      return int.tryParse(value.toString()) ?? 0;
    }

    return RatingData(
      averageRating: parseDouble(json['average_rating']),
      totalReviews: parseInt(json['total_reviews']),
      reviews:
          (json['reviews'] as List<dynamic>? ?? [])
              .map((e) => UserReview.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }

  String get formattedAverage {
    if (averageRating == null) return '0';
    if (averageRating! % 1 == 0) return averageRating!.toInt().toString();

    // truncate to 1 decimal without rounding
    double truncated = (averageRating! * 10).floorToDouble() / 10;
    return truncated.toStringAsFixed(1);
  }
}

class UserReview {
  final String reviews;
  final String userName;
  final String? profileImg;

  UserReview({required this.reviews, required this.userName, this.profileImg});

  factory UserReview.fromJson(Map<String, dynamic> json) {
    return UserReview(
      reviews: json['reviews'] as String? ?? '',
      userName: json['user_name'] as String? ?? 'Anonymous',
      profileImg: json['profile_img'] as String?,
    );
  }
}

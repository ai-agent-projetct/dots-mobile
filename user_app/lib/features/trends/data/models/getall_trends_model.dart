class GetAllTrendsResponseModel {
  final bool status;
  final List<TrendsModel> data;

  GetAllTrendsResponseModel({required this.status, required this.data});

  factory GetAllTrendsResponseModel.fromJson(Map<String, dynamic> json) {
    return GetAllTrendsResponseModel(
      status: json['status'],
      data:
          (json['data'] as List)
              .map((item) => TrendsModel.fromJson(item))
              .toList(),
    );
  }
}

class TrendsModel {
  final String mediaId;
  final String providerId;
  final String firstName;
  final String lastName;
  final String? profileImage;
  final String description;
  final String mediaFile;
  final String mediaType;
  final DateTime createdAt;
  final DateTime updatedAt;

  TrendsModel({
    required this.mediaId,
    required this.providerId,
    required this.firstName,
    required this.lastName,
    required this.profileImage,
    required this.description,
    required this.mediaFile,
    required this.mediaType,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TrendsModel.fromJson(Map<String, dynamic> json) {
    return TrendsModel(
      mediaId: json['media_id'] as String,
      providerId: json['provider_id'] as String,
      firstName: json['First_name'] as String,
      lastName: json['Last_name'] as String,
      profileImage: json['profile_image'] as String? ?? '',
      description: json['description'] as String,
      mediaFile: json['media_file'] as String,
      mediaType: json['media_type'] as String,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

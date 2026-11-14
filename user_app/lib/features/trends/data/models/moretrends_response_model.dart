class ProviderTrendsResponseModel {
  final bool status;
  final List<ProviderTrendsData> data;

  ProviderTrendsResponseModel({required this.status, required this.data});

  factory ProviderTrendsResponseModel.fromJson(Map<String, dynamic> json) {
    return ProviderTrendsResponseModel(
      status: json['status'] ?? false,
      data:
          (json['data'] as List<dynamic>?)
              ?.map((item) => ProviderTrendsData.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class ProviderTrendsData {
  final int id;
  final String mediaId;
  final String providerId;
  final int isActive;
  final String description;
  final String mediaFile;
  final String mediaType;
  final String? createdBy;
  final String? updatedBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String providerName;

  ProviderTrendsData({
    required this.id,
    required this.mediaId,
    required this.providerId,
    required this.isActive,
    required this.description,
    required this.mediaFile,
    required this.mediaType,
    required this.createdBy,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.providerName,
  });

  factory ProviderTrendsData.fromJson(Map<String, dynamic> json) {
    return ProviderTrendsData(
      id: json['id'] ?? 0,
      mediaId: json['media_id'] ?? '',
      providerId: json['provider_id'] ?? '',
      isActive: json['is_active'] ?? 0,
      description: json['description'] ?? '',
      mediaFile: json['media_file'] ?? '',
      mediaType: json['media_type'] ?? '',
      createdBy: json['created_by'],
      updatedBy: json['updated_by'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      providerName: json['provider_name'] ?? '',
    );
  }
}

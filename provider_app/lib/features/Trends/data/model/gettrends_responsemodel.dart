import 'package:intl/intl.dart';

class GetAllTrendsResponseModel {
  final bool status;
  final List<TrendItem> data;

  GetAllTrendsResponseModel({required this.status, required this.data});

  factory GetAllTrendsResponseModel.fromJson(Map<String, dynamic> json) {
    return GetAllTrendsResponseModel(
      status: json['status'] ?? false,
      data:
          (json['data'] as List<dynamic>?)
              ?.map((item) => TrendItem.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class TrendItem {
  final int id;
  final String mediaId;
  final String providerId;
  final int isActive;
  final String description;
  String? mediaFile;
  final String mediaType;
  final String createdBy;
  final String? updatedBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String providerName;

  TrendItem({
    required this.id,
    required this.mediaId,
    required this.providerId,
    required this.isActive,
    required this.description,
    required this.mediaFile,
    required this.mediaType,
    required this.createdBy,
    this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.providerName,
  });

  factory TrendItem.fromJson(Map<String, dynamic> json) {
    return TrendItem(
      id: json['id'] ?? 0,
      mediaId: json['media_id'] ?? '',
      providerId: json['provider_id'] ?? '',
      isActive: json['is_active'] ?? 0,
      description: json['description'] ?? '',
      mediaFile: json['media_file'] ?? '',
      mediaType: json['media_type'] ?? '',
      createdBy: json['created_by'] ?? '',
      updatedBy: json['updated_by'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      providerName: json['provider_name'] ?? '',
    );
  }

  /// Format date like "01 Jan 2025"
  String get formattedCreatedAt => DateFormat('dd MMM yyyy').format(createdAt);

  String get formattedUpdatedAt => DateFormat('dd MMM yyyy').format(updatedAt);
}

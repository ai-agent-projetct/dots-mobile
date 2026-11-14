import 'package:intl/intl.dart';

class GetAllOffersResponseModel {
  final bool status;
  final String message;
  final List<OfferItem> data;

  GetAllOffersResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory GetAllOffersResponseModel.fromJson(Map<String, dynamic> json) {
    return GetAllOffersResponseModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data:
          (json['data'] as List<dynamic>?)
              ?.map((item) => OfferItem.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class OfferItem {
  final int id;
  final String offerId;
  final String providerId;
  final String title;
  final String description;
  final int isActive;
  final String discount;
  final String categoryId;
  final String subCategoryId;
  final String uploadImage;
  final String startDate;
  final String expiryDate;
  final String createdAt;
  final String? updatedAt;
  final int isDelete;

  OfferItem({
    required this.id,
    required this.offerId,
    required this.providerId,
    required this.title,
    required this.description,
    required this.isActive,
    required this.discount,
    required this.categoryId,
    required this.subCategoryId,
    required this.uploadImage,
    required this.startDate,
    required this.expiryDate,
    required this.createdAt,
    this.updatedAt,
    required this.isDelete,
  });

  static String formatDate(String dateString) {
    try {
      final dateTime = DateTime.parse(dateString);
      return DateFormat('dd/MM/yyyy').format(dateTime);
    } catch (e) {
      return dateString;
    }
  }

  factory OfferItem.fromJson(Map<String, dynamic> json) {
    return OfferItem(
      id: json['id'] ?? 0,
      offerId: json['offer_id'] ?? '',
      providerId: json['provider_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      isActive: json['is_active'] ?? 0,
      discount: json['discount'] ?? '',
      categoryId: json['category_id'] ?? '',
      subCategoryId: json['sub_category_id'] ?? '',
      uploadImage: json['upload_image'] ?? '',
      startDate: formatDate(json['start_date'] ?? ''),
      expiryDate: formatDate(json['expiry_date'] ?? ''),
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'],
      isDelete: json['is_delete'] ?? 0,
    );
  }
}

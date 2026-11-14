import 'dart:developer';

class GetAllOfferResponseModel {
  final bool status;
  final String message;
  final Map<String, List<Offer>> data;

  GetAllOfferResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory GetAllOfferResponseModel.fromJson(Map<String, dynamic> json) {
    final Map<String, List<Offer>> parsedData = {};
    (json['data'] as Map<String, dynamic>).forEach((key, value) {
      parsedData[key] = (value as List).map((e) => Offer.fromJson(e)).toList();
    });

    return GetAllOfferResponseModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: parsedData,
    );
  }

  // factory GetAllOfferResponseModel.fromJson(Map<String, dynamic> json) {
  //   final rawData = json['data'];

  //   if (rawData is Map<String, dynamic>) {
  //     final Map<String, List<Offer>> parsedData = {};
  //     rawData.forEach((key, value) {
  //       parsedData[key] =
  //           (value as List)
  //               .map((e) => Offer.fromJson(e as Map<String, dynamic>))
  //               .toList();
  //     });

  //     return GetAllOfferResponseModel(
  //       status: json['status'] ?? false,
  //       message: json['message'] ?? '',
  //       data: parsedData,
  //     );
  //   } else if (rawData is List) {
  //     // if backend returns an empty list
  //     return GetAllOfferResponseModel(
  //       status: json['status'] ?? false,
  //       message: json['message'] ?? '',
  //       data: {},
  //     );
  //   } else {
  //     throw Exception(
  //       "Unexpected data format for 'data': ${rawData.runtimeType}",
  //     );
  //   }
  // }

  factory GetAllOfferResponseModel.selectedoffersfromJson(
    Map<String, dynamic> json,
  ) {
    final Map<String, List<Offer>> parsedData =
        (json['data'] as Map<String, dynamic>).map((key, value) {
          return MapEntry(
            key,
            (value as List)
                .map((e) => Offer.fromJson(e as Map<String, dynamic>))
                .toList(),
          );
        });

    return GetAllOfferResponseModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: parsedData,
    );
  }
}

class Offer {
  final String offerId;
  final String categoryId;
  final String subCategoryId;
  final String subCategoryName;
  final String title;
  final String description;
  final String discount;
  final DateTime startDate;
  final DateTime expiryDate;
  final String uploadImage;
  final int isActive;

  Offer({
    required this.offerId,
    required this.categoryId,
    required this.subCategoryId,
    required this.subCategoryName,
    required this.title,
    required this.description,
    required this.discount,
    required this.startDate,
    required this.expiryDate,
    required this.uploadImage,
    required this.isActive,
  });

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      offerId: json['offer_id'] ?? '',
      categoryId: json['category_id'] ?? '',
      subCategoryId: json['sub_category_id'] ?? '',
      subCategoryName: json['sub_category_name'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      discount: json['discount'] ?? '',
      startDate: DateTime.parse(json['start_date']),
      expiryDate: DateTime.parse(json['expiry_date']),
      uploadImage: json['upload_image'] ?? '',
      isActive: json['is_active'] ?? 0,
    );
  }
}

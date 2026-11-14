class SubCategoryListResponseModel {
  final bool status;
  final String message;
  final List<SubCategoryListData> data;

  SubCategoryListResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory SubCategoryListResponseModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryListResponseModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data:
          (json['data'] as List<dynamic>?)
              ?.map((item) => SubCategoryListData.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class SubCategoryListData {
  final String categoryId;
  final String catId;
  final String categoryName;
  final String subCategoryId;
  final String subId;
  final String subCategoryName;
  final String subCategoryImage;

  SubCategoryListData({
    required this.categoryId,
    required this.catId,
    required this.categoryName,
    required this.subCategoryId,
    required this.subId,
    required this.subCategoryName,
    required this.subCategoryImage,
  });

  factory SubCategoryListData.fromJson(Map<String, dynamic> json) {
    return SubCategoryListData(
      categoryId: json['category_id'] ?? '',
      catId: json['cat_id'] ?? '',
      categoryName: json['category_name'] ?? '',
      subCategoryId: json['sub_category_id'] ?? '',
      subId: json['sub_id'] ?? '',
      subCategoryName: json['sub_category_name'] ?? '',
      subCategoryImage: json['sub_category_image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category_id': categoryId,
      'cat_id': catId,
      'category_name': categoryName,
      'sub_category_id': subCategoryId,
      'sub_id': subId,
      'sub_category_name': subCategoryName,
      'sub_category_image': subCategoryImage,
    };
  }
}

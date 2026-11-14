class SubCategoryResponseModel {
  final bool status;
  final String message;
  final List<SubCategoryModel> data;

  SubCategoryResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory SubCategoryResponseModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryResponseModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data:
          (json['data'] as List<dynamic>)
              .map((e) => SubCategoryModel.fromJson(e))
              .toList(),
    );
  }
}

class SubCategoryModel {
  final int id;
  final String subCategoryId;
  final String categoryId;
  final String subId;
  final String subCategoryName;
  final String uploadImage;
  final String description;
  final int isActive;
  final String createAt;
  final String updateAt;
  final String createdBy;
  final String updatedBy;
  final int isDashboard;
  final String categoryName;

  SubCategoryModel({
    required this.id,
    required this.subCategoryId,
    required this.categoryId,
    required this.subId,
    required this.subCategoryName,
    required this.uploadImage,
    required this.description,
    required this.isActive,
    required this.createAt,
    required this.updateAt,
    required this.createdBy,
    required this.updatedBy,
    required this.isDashboard,
    required this.categoryName,
  });

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      id: json['id'] ?? 0,
      subCategoryId: json['sub_category_id'] ?? '',
      categoryId: json['category_id'] ?? '',
      subId: json['sub_id'] ?? '',
      subCategoryName: json['sub_category_name'] ?? '',
      uploadImage: json['upload_image'] ?? '',
      description: json['description'] ?? '',
      isActive: json['isActive'] ?? 0,
      createAt: json['CreateAt'] ?? '',
      updateAt: json['UpdateAt'] ?? '',
      createdBy: json['created_by'] ?? '',
      updatedBy: json['updated_by'] ?? '',
      isDashboard: json['is_dashboard'] ?? 0,
      categoryName: json['category_name'] ?? '',
    );
  }
}

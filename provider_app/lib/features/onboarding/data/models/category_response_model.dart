class CategoryResponseModel {
  final bool status;
  final String message;
  final List<CategoryModel> data;

  CategoryResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CategoryResponseModel.fromJson(Map<String, dynamic> json) {
    return CategoryResponseModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => CategoryModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'data': data.map((e) => e.toJson()).toList(),
  };
}

class CategoryModel {
  final int id;
  final String categoryId;
  final String catId;
  final String categoryName;
  final String uploadImage;
  final String description;
  final int isActive;
  final String createAt;
  final String updateAt;
  final String createdBy;
  final String updatedBy;
  final String icon;

  CategoryModel({
    required this.id,
    required this.categoryId,
    required this.catId,
    required this.categoryName,
    required this.uploadImage,
    required this.description,
    required this.isActive,
    required this.createAt,
    required this.updateAt,
    required this.createdBy,
    required this.updatedBy,
    required this.icon,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? 0,
      categoryId: json['category_id'] ?? '',
      catId: json['cat_id'] ?? '',
      categoryName: json['category_name'] ?? '',
      uploadImage: json['upload_image'] ?? '',
      description: json['description'] ?? '',
      isActive: json['isActive'] ?? 0,
      createAt: json['CreateAt'] ?? '',
      updateAt: json['UpdateAt'] ?? '',
      createdBy: json['created_by'] ?? '',
      updatedBy: json['updated_by'] ?? '',
      icon: json['icon'] ?? '',
    );
  }
  Map<String, dynamic> toJson() => {
    'id': id,
    'category_id': categoryId,
    'cat_id': catId,
    'category_name': categoryName,
    'upload_image': uploadImage,
    'description': description,
    'isActive': isActive,
    'CreateAt': createAt,
    'UpdateAt': updateAt,
    'created_by': createdBy,
    'updated_by': updatedBy,
    'icon': icon,
  };
}

class SelectedServicesResponseModel {
  final bool status;
  final String message;
  final SelectedServicesData data;

  SelectedServicesResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory SelectedServicesResponseModel.fromJson(Map<String, dynamic> json) {
    return SelectedServicesResponseModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: SelectedServicesData.fromJson(json['data'] ?? {}),
    );
  }
}

class SelectedServicesData {
  final List<CategoryModel> categories;
  final List<SubCategoryModel> subcategories;

  SelectedServicesData({required this.categories, required this.subcategories});

  factory SelectedServicesData.fromJson(Map<String, dynamic> json) {
    return SelectedServicesData(
      categories:
          (json['categories'] as List<dynamic>?)
              ?.map((e) => CategoryModel.fromJson(e))
              .toList() ??
          [],
      subcategories:
          (json['subcategories'] as List<dynamic>?)
              ?.map((e) => SubCategoryModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class CategoryModel {
  final String categoryId;
  final String catId;
  final String categoryName;
  final String categoryImage;

  CategoryModel({
    required this.categoryId,
    required this.catId,
    required this.categoryName,
    required this.categoryImage,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      categoryId: json['category_id'] ?? '',
      catId: json['cat_id'] ?? '',
      categoryName: json['category_name'] ?? '',
      categoryImage: json['category_image'] ?? '',
    );
  }
}

class SubCategoryModel {
  final String categoryId;
  final String subCategoryId;
  final String subId;
  final String subCategoryName;
  final String subCategoryImage;

  SubCategoryModel({
    required this.categoryId,
    required this.subCategoryId,
    required this.subId,
    required this.subCategoryName,
    required this.subCategoryImage,
  });

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      categoryId: json['category_id'] ?? '',
      subCategoryId: json['sub_category_id'] ?? '',
      subId: json['sub_id'] ?? '',
      subCategoryName: json['sub_category_name'] ?? '',
      subCategoryImage: json['sub_category_image'] ?? '',
    );
  }
}

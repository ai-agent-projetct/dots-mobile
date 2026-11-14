class CategoryResponseModel {
  CategoryResponseModel({
    this.categoryId,
    this.catId,
    this.categoryName,
    this.description,
    this.catImg,
    this.isActive,
    this.catIcon,
  });

  dynamic categoryId;
  dynamic catId;
  dynamic categoryName;
  dynamic description;
  dynamic catImg;
  dynamic isActive;
  dynamic catIcon;

  factory CategoryResponseModel.fromJson(Map<String, dynamic> json) =>
      CategoryResponseModel(
        categoryId: json["category_id"],
        catId: json["cat_id"],
        categoryName: json["category_name"],
        description: json['description'] ?? '',
        catImg: json["upload_image"],
        isActive: json["isActive"],
        catIcon: json["icon"],
      );

  Map<String, dynamic> toJson() => {
        "category_id": categoryId,
        "cat_id": catId,
        "category_name": categoryName,
        "description": description,
        "upload_image": catImg,
        "isActive": isActive,
        "icon": catIcon
      };
}

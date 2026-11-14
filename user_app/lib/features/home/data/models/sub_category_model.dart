class SubCategoryResponseModel {
  SubCategoryResponseModel({
    this.subId,
    this.subCategoryId,
    this.subCategoryName,
    this.description,
    this.subCatImg,
  });

  dynamic subId;
  dynamic subCategoryId;
  dynamic subCategoryName;
  dynamic description;
  dynamic subCatImg;

  factory SubCategoryResponseModel.fromJson(Map<String, dynamic> json) =>
      SubCategoryResponseModel(
        subId: json["sub_id"],
        subCategoryId: json["sub_category_id"],
        subCategoryName: json["sub_category_name"],
        description: json['description'],
        subCatImg: json["upload_image"],
      );

  Map<String, dynamic> toJson() => {
        "sub_id": subId,
        "sub_category_id": subCategoryId,
        "sub_category_name": subCategoryName,
        "description": description,
        "upload_image": subCatImg,
      };
}

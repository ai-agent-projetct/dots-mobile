import 'package:user/features/home/data/models/category_model.dart';
import 'package:user/features/home/data/models/sub_category_model.dart';

class DashboardResponseModel {
  DashboardResponseModel({this.status, this.msg, this.dashboardData});

  dynamic status;
  dynamic msg;
  List<DashboardData>? dashboardData;

  factory DashboardResponseModel.fromJson(Map<String, dynamic> json) =>
      DashboardResponseModel(
        status: json["status"],
        msg: json["message"],
        dashboardData:
            json["data"] != null
                ? List<DashboardData>.from(
                  json["data"].map((x) => DashboardData.fromJson(x)),
                )
                : [],
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": msg,
    "data": List<dynamic>.from(dashboardData!.map((x) => x.toJson())),
  };
}

class DashboardData {
  CategoryResponseModel? categoryResponseModel;
  List<SubCategoryResponseModel>? subCategoryModel;

  DashboardData({this.categoryResponseModel, this.subCategoryModel});

  factory DashboardData.fromJson(Map<String, dynamic> json) => DashboardData(
    categoryResponseModel: CategoryResponseModel.fromJson(
      json["categories"] ?? {},
    ),
    subCategoryModel:
        json["subCategories"] != null
            ? List<SubCategoryResponseModel>.from(
              json["subCategories"].map(
                (x) => SubCategoryResponseModel.fromJson(x),
              ),
            )
            : [],
  );

  Map<String, dynamic> toJson() => {
    "categories": categoryResponseModel?.toJson(),
    "subCategories": List<dynamic>.from(
      subCategoryModel!.map((x) => x.toJson()),
    ),
  };
}

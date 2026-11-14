import 'package:user/features/home/data/models/sub_category_model.dart';

class ProvidersListResponseModel {
  ProvidersListResponseModel({
    this.status,
    this.msg,
    this.count,
    this.providersData,
  });

  dynamic status;
  dynamic msg;
  dynamic count;
  List<ProvidersData>? providersData;

  factory ProvidersListResponseModel.fromJson(Map<String, dynamic> json) =>
      ProvidersListResponseModel(
        status: json["status"],
        msg: json["message"],
        count: json["count"],
        providersData:
            json["data"] != null
                ? List<ProvidersData>.from(
                  json["data"].map((x) => ProvidersData.fromJson(x)),
                )
                : [],
      );
}

class ProvidersData {
  dynamic id;
  dynamic providerID;
  dynamic proID;
  dynamic roleId;
  dynamic firstName;
  dynamic lastName;
  dynamic emailAddress;
  dynamic phoneNumber;
  dynamic address;
  dynamic latitude;
  dynamic longitude;
  dynamic distance;
  SubCategoryResponseModel? subCategoryResponseModel;

  dynamic averageRating; // dynamic now
  dynamic totalReviews; // dynamic now

  ProvidersData({
    this.id,
    this.providerID,
    this.proID,
    this.roleId,
    this.firstName,
    this.lastName,
    this.emailAddress,
    this.phoneNumber,
    this.address,
    this.latitude,
    this.longitude,
    this.distance,
    this.subCategoryResponseModel,
    this.averageRating,
    this.totalReviews,
  });

  factory ProvidersData.fromJson(Map<String, dynamic> json) => ProvidersData(
    id: json["ID"],
    providerID: json["Provider_ID"],
    proID: json["pro_id"],
    roleId: json["Role_ID"],
    firstName: json["First_name"],
    lastName: json["Last_name"],
    emailAddress: json["Email_Address"],
    phoneNumber: json["Phone_number"],
    address: json["Address"],
    latitude: json["Latitude"],
    longitude: json["Longitude"],
    distance: json["distance"],
    subCategoryResponseModel: SubCategoryResponseModel.fromJson(
      json["sub_category"] ?? {},
    ),
    averageRating: json['average_rating'],
    totalReviews: json['total_reviews'],
  );

  /// Safely converts averageRating to double
  double get averageRatingDouble {
    if (averageRating == null) return 0;
    if (averageRating is int) return (averageRating as int).toDouble();
    if (averageRating is double) return averageRating;
    return double.tryParse(averageRating.toString()) ?? 0;
  }

  /// Safely converts totalReviews to int
  int get totalReviewsInt {
    if (totalReviews == null) return 0;
    if (totalReviews is int) return totalReviews;
    if (totalReviews is double) return (totalReviews as double).toInt();
    return int.tryParse(totalReviews.toString()) ?? 0;
  }

  /// Returns average rating formatted as string
  String get formattedAverage {
    double value = averageRatingDouble;
    if (value % 1 == 0) return value.toInt().toString();

    // truncate to 1 decimal without rounding
    double truncated = (value * 10).floorToDouble() / 10;
    return truncated.toStringAsFixed(1);
  }
}

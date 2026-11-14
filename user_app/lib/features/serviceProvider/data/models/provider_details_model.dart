// import 'package:user/features/home/data/models/sub_category_model.dart';

// class ProviderDetailsResponseModel {
//   ProviderDetailsResponseModel({
//     this.status,
//     this.msg,
//     this.count,
//     this.providerDetailsData,
//   });

//   dynamic status;
//   dynamic msg;
//   dynamic count;
//   ProviderDetailsData? providerDetailsData;

//   factory ProviderDetailsResponseModel.fromJson(Map<String, dynamic> json) =>
//       ProviderDetailsResponseModel(
//           status: json["status"],
//           msg: json["message"],
//           count: json["count"],
//           providerDetailsData:
//               ProviderDetailsData.fromJson(json["data"] ?? {}));

//   Map<String, dynamic> toJson() => {
//         "status": status,
//         "message": msg,
//         "count": count,
//         "data": providerDetailsData!.toJson(),
//       };
// }

// class ProviderDetailsData {
//   dynamic id;
//   dynamic providerID;
//   dynamic proID;
//   dynamic roleId;
//   dynamic firstName;
//   dynamic lastName;
//   dynamic emailAddress;
//   dynamic phoneNumber;
//   dynamic address;
//   dynamic latitude;
//   dynamic longitude;
//   dynamic distance;
//   List<SubCategoryResponseModel>? subCategoryResponseModel;

//   ProviderDetailsData({
//     this.id,
//     this.providerID,
//     this.proID,
//     this.roleId,
//     this.firstName,
//     this.lastName,
//     this.emailAddress,
//     this.phoneNumber,
//     this.address,
//     this.latitude,
//     this.longitude,
//     this.distance,
//     this.subCategoryResponseModel,
//   });

//   factory ProviderDetailsData.fromJson(Map<String, dynamic> json) =>
//       ProviderDetailsData(
//         id: json["ID"],
//         providerID: json["Provider_ID"],
//         proID: json["pro_id"],
//         roleId: json["Role_ID"],
//         firstName: json["First_name"],
//         lastName: json["Last_name"],
//         emailAddress: json["Email_Address"],
//         phoneNumber: json["Phone_number"],
//         address: json["Address"],
//         latitude: json["Latitude"],
//         longitude: json["Longitude"],
//         distance: json["distance"],
//         subCategoryResponseModel: json["subcategories"] != null
//             ? List<SubCategoryResponseModel>.from(json["subcategories"]
//                 .map((x) => SubCategoryResponseModel.fromJson(x)))
//             : [],
//       );

//   Map<String, dynamic> toJson() => {
//         "ID": id,
//         "Provider_ID": providerID,
//         "pro_id": proID,
//         "Role_ID": roleId,
//         "First_name": firstName,
//         "Last_name": lastName,
//         "Email_Address": emailAddress,
//         "Phone_number": phoneNumber,
//         "Address": address,
//         "Latitude": latitude,
//         "Longitude": longitude,
//         "distance": distance,
//         "subcategories": List<dynamic>.from(
//             subCategoryResponseModel!.map((x) => x.toJson())),
//       };
// }

import 'package:user/features/home/data/models/sub_category_model.dart';

class ProviderDetailsResponseModel {
  ProviderDetailsResponseModel({
    this.status,
    this.msg,
    this.count,
    this.providerDetailsData,
  });

  dynamic status;
  dynamic msg;
  dynamic count;
  ProviderDetailsData? providerDetailsData;

  factory ProviderDetailsResponseModel.fromJson(Map<String, dynamic> json) =>
      ProviderDetailsResponseModel(
        status: json["status"],
        msg: json["message"],
        count: json["count"],
        providerDetailsData:
            json["data"] != null
                ? ProviderDetailsData.fromJson(json["data"])
                : null,
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": msg,
    "count": count,
    "data": providerDetailsData?.toJson(),
  };
}

class ProviderDetailsData {
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
  dynamic profileImage;
  dynamic description;
  dynamic fcmToken;

  List<SubCategoryResponseModel>? subCategoryResponseModel;
  List<WorkResponseModel>? works;

  ProviderDetailsData({
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
    this.profileImage,
    this.description,
    this.fcmToken,
    this.subCategoryResponseModel,
    this.works,
  });

  factory ProviderDetailsData.fromJson(Map<String, dynamic> json) =>
      ProviderDetailsData(
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
        profileImage: json["profile_image"],
        description: json["description"],
        fcmToken: json["fcm_token"],
        subCategoryResponseModel:
            json["subcategories"] != null
                ? List<SubCategoryResponseModel>.from(
                  json["subcategories"].map(
                    (x) => SubCategoryResponseModel.fromJson(x),
                  ),
                )
                : [],
        works:
            json["works"] != null
                ? List<WorkResponseModel>.from(
                  json["works"].map((x) => WorkResponseModel.fromJson(x)),
                )
                : [],
      );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "Provider_ID": providerID,
    "pro_id": proID,
    "Role_ID": roleId,
    "First_name": firstName,
    "Last_name": lastName,
    "Email_Address": emailAddress,
    "Phone_number": phoneNumber,
    "Address": address,
    "Latitude": latitude,
    "Longitude": longitude,
    "distance": distance,
    "profile_image": profileImage,
    "description": description,
    "fcm_token": fcmToken,
    "subcategories":
        subCategoryResponseModel != null
            ? List<dynamic>.from(
              subCategoryResponseModel!.map((x) => x.toJson()),
            )
            : [],
    "works":
        works != null ? List<dynamic>.from(works!.map((x) => x.toJson())) : [],
  };
}

class WorkResponseModel {
  dynamic workId;
  dynamic mediaUrl;
  dynamic mediaType;

  WorkResponseModel({this.workId, this.mediaUrl, this.mediaType});

  factory WorkResponseModel.fromJson(Map<String, dynamic> json) =>
      WorkResponseModel(
        workId: json["work_id"],
        mediaUrl: json["media_url"],
        mediaType: json["media_type"],
      );

  Map<String, dynamic> toJson() => {
    "work_id": workId,
    "media_url": mediaUrl,
    "media_type": mediaType,
  };
}

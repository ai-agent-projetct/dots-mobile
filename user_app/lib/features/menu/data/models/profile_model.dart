class ProfileResponseModel {
  ProfileResponseModel({
    this.status,
    this.msg,
    this.data,
  });

  dynamic status;
  dynamic msg;
  ProfileData? data;

  factory ProfileResponseModel.fromJson(Map<String, dynamic> json) =>
      ProfileResponseModel(
        status: json["status"],
        msg: json["message"],
        data: ProfileData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": msg,
        "data": data?.toJson(),
      };
}

class ProfileData {
  ProfileData({
    this.userId,
    this.image,
    this.fullName,
    this.email,
    this.mobile,
    this.roleId,
  });

  dynamic userId;
  dynamic image;
  dynamic fullName;
  dynamic email;
  dynamic mobile;
  dynamic roleId;

  factory ProfileData.fromJson(Map<String, dynamic> json) => ProfileData(
        userId: json["User_ID"],
        image: json["profile_img"],
        fullName: json["Full_name"],
        email: json['Email_Address'] ?? '',
        mobile: json["Phone_number"],
        roleId: json["Role_ID"],
      );

  Map<String, dynamic> toJson() => {
        "User_ID": userId,
        "profile_img": image,
        "Full_name": fullName,
        "Email_Address": email,
        "Phone_number": mobile,
        "Role_ID": roleId,
      };
}

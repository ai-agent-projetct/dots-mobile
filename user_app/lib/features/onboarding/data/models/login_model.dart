class LoginResponseModel {
  LoginResponseModel({
    this.status,
    this.msg,
    this.data,
  });

  dynamic status;
  dynamic msg;
  Data? data;

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      LoginResponseModel(
        status: json["status"],
        msg: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": msg,
        "data": data?.toJson(),
      };
}

class Data {
  Data({
    this.token,
    this.userId,
    this.image,
    this.fullName,
    this.email,
    this.mobile,
    this.roleId,
    this.isLogin,
  });

  dynamic token;
  dynamic userId;
  dynamic image;
  dynamic fullName;
  dynamic email;
  dynamic mobile;
  dynamic roleId;
  dynamic isLogin;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        token: json["token"],
        userId: json["User_ID"],
        image: json["profile_img"],
        fullName: json["Full_name"],
        email: json['Email_Address'] ?? '',
        mobile: json["Phone_number"],
        roleId: json["Role_ID"],
        isLogin: json["isLogin"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "User_ID": userId,
        "profile_img": image,
        "Full_name": fullName,
        "Email_Address": email,
        "Phone_number": mobile,
        "Role_ID": roleId,
        "isLogin": isLogin,
      };
}

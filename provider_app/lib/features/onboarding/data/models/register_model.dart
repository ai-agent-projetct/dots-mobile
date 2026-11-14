class RegisterResponseModel {
  RegisterResponseModel({this.status, this.msg, this.data});

  dynamic status;
  dynamic msg;
  Data? data;

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) =>
      RegisterResponseModel(
        status: json["status"],
        msg: json["message"],
        data: json['data'] != null ? Data.fromJson(json['data']) : null,
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": msg,
    "data": data?.toJson(),
  };
}

class Data {
  Data({this.userId});

  dynamic userId;

  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(userId: json["User_ID"]);

  Map<String, dynamic> toJson() => {"User_ID": userId};
}

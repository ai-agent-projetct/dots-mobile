class CheckUserResponseModel {
  CheckUserResponseModel({
    this.status,
    this.msg,
    this.data,
  });

  bool? status;
  String? msg;
  Data? data;

  factory CheckUserResponseModel.fromJson(Map<String, dynamic> json) =>
      CheckUserResponseModel(
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
    this.isUserExists,
  });

  dynamic isUserExists;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        isUserExists: json["isUserExists"],
      );

  Map<String, dynamic> toJson() => {
        "isUserExists": isUserExists,
      };
}

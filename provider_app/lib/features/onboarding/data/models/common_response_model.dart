class CommonResponseModel {
  CommonResponseModel({this.status, this.msg, this.data});

  dynamic status;
  dynamic msg;
  dynamic data;

  factory CommonResponseModel.fromJson(Map<String, dynamic> json) =>
      CommonResponseModel(
        status: json["status"],
        msg: json["message"],
        data: json.containsKey("data") ? json["data"] : null,
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": msg,
    if (data != null) "data": data,
  };
}

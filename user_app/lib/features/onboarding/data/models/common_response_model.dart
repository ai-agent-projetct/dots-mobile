class CommonResponseModel {
  CommonResponseModel({
    this.status,
    this.msg,
    this.data,
  });

  dynamic status;
  dynamic msg;
  dynamic data;

  factory CommonResponseModel.fromJson(Map<String, dynamic> json) =>
      CommonResponseModel(
        status: json["status"],
        msg: json["message"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": msg,
        "data": data,
      };
}

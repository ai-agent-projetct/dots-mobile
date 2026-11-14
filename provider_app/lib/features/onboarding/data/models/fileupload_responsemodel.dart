class FileUploadResponseModel {
  FileUploadResponseModel({this.status, this.msg, this.data});

  bool? status;
  String? msg;
  Data? data;

  factory FileUploadResponseModel.fromJson(Map<String, dynamic> json) =>
      FileUploadResponseModel(
        status: json["status"],
        msg: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": msg,
    "data": data!.toJson(),
  };
}

class Data {
  Data({this.imageUrl});

  String? imageUrl;

  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(imageUrl: json["url"]);

  Map<String, dynamic> toJson() => {"url": imageUrl};
}

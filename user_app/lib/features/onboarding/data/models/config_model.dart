class ConfigModel {
  ConfigModel({
    this.status,
    this.msg,
    this.data,
  });

  dynamic status;
  dynamic msg;
  Data? data;

  factory ConfigModel.fromJson(Map<String, dynamic> json) => ConfigModel(
        status: json["status"],
        msg: json["msg"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "data": data?.toJson(),
      };
}

class Data {
  Data({
    this.privacyPolicy,
    this.termsAndConditions,
    this.appConfig,
    this.onboardingVideo,
    this.slider,
  });

  dynamic privacyPolicy;
  dynamic termsAndConditions;
  AppConfig? appConfig;
  dynamic onboardingVideo;
  List<SliderModel>? slider;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        privacyPolicy: json["privacyPolicy"],
        termsAndConditions: json["termsAndConditions"],
        appConfig: AppConfig.fromJson(json["appconfig"]),
        onboardingVideo: json["video_url"],
        slider: json["slider"] == null
            ? []
            : List<SliderModel>.from(
                json["slider"].map((x) => SliderModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "privacyPolicy": privacyPolicy,
        "termsAndConditions": termsAndConditions,
        "video_url": onboardingVideo,
        "appconfig": appConfig!.toJson(),
        "slider": List<dynamic>.from(slider!.map((x) => x.toJson())),
      };
}

class AppConfig {
  AppConfig({
    this.authType,
    this.referralEnabled,
    this.referralThreshold,
  });

  dynamic authType;
  dynamic referralEnabled;
  dynamic referralThreshold;

  factory AppConfig.fromJson(Map<String, dynamic> json) => AppConfig(
        authType: json["auth_type"],
        referralEnabled: json["referral_enabled"],
        referralThreshold: json["referral_threshold"],
      );

  Map<String, dynamic> toJson() => {
        "auth_type": authType,
        "referral_enabled": referralEnabled,
        "referral_threshold": referralThreshold,
      };
}

class SliderModel {
  SliderModel({
    this.id,
    this.title,
    this.description,
    this.image,
  });

  int? id;
  String? title;
  String? description;
  String? image;

  factory SliderModel.fromJson(Map<String, dynamic> json) => SliderModel(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "image": image,
      };
}

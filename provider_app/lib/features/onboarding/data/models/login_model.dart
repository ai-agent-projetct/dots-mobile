class LoginResponseModel {
  final bool status;
  final String message;
  final LoginData data;

  LoginResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      status: json['status'],
      message: json['message'],
      data: LoginData.fromJson(json['data']),
    );
  }
}

class LoginData {
  final String token;
  final String providerId;
  final String proId;
  final String firstName;
  final String lastName;
  final String emailAddress;
  final String phoneNumber;
  final int roleId;
  final String? gst;
  final String subscriptionStatus;
  final String address;
  final String latitude;
  final String longitude;
  final String profileImage;

  LoginData({
    required this.token,
    required this.providerId,
    required this.proId,
    required this.firstName,
    required this.lastName,
    required this.emailAddress,
    required this.phoneNumber,
    required this.roleId,
    this.gst,
    required this.subscriptionStatus,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.profileImage,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      token: json['token'] ?? '',
      providerId: json['Provider_ID'] ?? '',
      proId: json['pro_id'] ?? '',
      firstName: json['First_name'] ?? '',
      lastName: json['Last_name'] ?? '',
      emailAddress: json['Email_Address'] ?? '',
      phoneNumber: json['Phone_number'] ?? '',
      roleId: json['Role_ID'] ?? '',
      gst: json['gst'] ?? '',
      address: json['address'] ?? '',
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
      profileImage: json['profile_image'] ?? '',
      subscriptionStatus: json['subscription_status'] ?? '',
    );
  }
}

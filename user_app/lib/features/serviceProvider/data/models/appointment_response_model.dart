class AppointmentResponseModel {
  final bool status;
  final String message;
  final AppointmentData data;

  AppointmentResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AppointmentResponseModel.fromJson(Map<String, dynamic> json) {
    return AppointmentResponseModel(
      status: json["status"] ?? false,
      message: json["message"] ?? "",
      data: AppointmentData.fromJson(json["data"] ?? {}),
    );
  }
}

class AppointmentData {
  final String appointmentId;
  final String appointmentToken;
  final String userId;
  final String providerId;
  final String appointmentTime;
  final String status;
  final String notes;
  final String userName;
  final String userContactEmail;
  final String userContactPhone;
  final String providerContactEmail;
  final String providerContactPhone;
  final String createdBy;
  final String updatedBy;

  AppointmentData({
    required this.appointmentId,
    required this.appointmentToken,
    required this.userId,
    required this.providerId,
    required this.appointmentTime,
    required this.status,
    required this.notes,
    required this.userName,
    required this.userContactEmail,
    required this.userContactPhone,
    required this.providerContactEmail,
    required this.providerContactPhone,
    required this.createdBy,
    required this.updatedBy,
  });

  factory AppointmentData.fromJson(Map<String, dynamic> json) {
    return AppointmentData(
      appointmentId: json["appointment_id"] ?? "",
      appointmentToken: json["appointment_token"] ?? "",
      userId: json["user_id"] ?? "",
      providerId: json["provider_id"] ?? "",
      appointmentTime: json["appointment_time"] ?? "",
      status: json["status"] ?? "",
      notes: json["notes"] ?? "",
      userName: json["user_name"] ?? "",
      userContactEmail: json["user_contact_email"] ?? "",
      userContactPhone: json["user_contact_phone"] ?? "",
      providerContactEmail: json["provider_contact_email"] ?? "",
      providerContactPhone: json["provider_contact_phone"] ?? "",
      createdBy: json["created_by"] ?? "",
      updatedBy: json["updated_by"] ?? "",
    );
  }
}

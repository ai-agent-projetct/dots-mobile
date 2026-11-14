class GetAppointmentsResponseModel {
  final bool status;
  final String message;
  final List<AppointmentData> data;

  GetAppointmentsResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory GetAppointmentsResponseModel.fromJson(Map<String, dynamic> json) {
    return GetAppointmentsResponseModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data:
          json['data'] != null
              ? List<AppointmentData>.from(
                json['data'].map((x) => AppointmentData.fromJson(x)),
              )
              : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "message": message,
      "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
  }
}

class AppointmentData {
  final int id;
  final String appointmentId;
  final String appointmentToken;
  final String userId;
  final String providerId;
  final String appointmentTime;
  final String status;
  final String notes;
  final String userContactEmail;
  final String userContactPhone;
  final String providerContactEmail;
  final String providerContactPhone;
  final String createdBy;
  final String updatedBy;
  final String createdAt;
  final String updatedAt;

  AppointmentData({
    required this.id,
    required this.appointmentId,
    required this.appointmentToken,
    required this.userId,
    required this.providerId,
    required this.appointmentTime,
    required this.status,
    required this.notes,
    required this.userContactEmail,
    required this.userContactPhone,
    required this.providerContactEmail,
    required this.providerContactPhone,
    required this.createdBy,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AppointmentData.fromJson(Map<String, dynamic> json) {
    return AppointmentData(
      id: json['id'] ?? 0,
      appointmentId: json['appointment_id'] ?? '',
      appointmentToken: json['appointment_token'] ?? '',
      userId: json['user_id'] ?? '',
      providerId: json['provider_id'] ?? '',
      appointmentTime: json['appointment_time'] ?? '',
      status: json['status'] ?? '',
      notes: json['notes'] ?? '',
      userContactEmail: json['user_contact_email'] ?? '',
      userContactPhone: json['user_contact_phone'] ?? '',
      providerContactEmail: json['provider_contact_email'] ?? '',
      providerContactPhone: json['provider_contact_phone'] ?? '',
      createdBy: json['created_by'] ?? '',
      updatedBy: json['updated_by'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "appointment_id": appointmentId,
      "appointment_token": appointmentToken,
      "user_id": userId,
      "provider_id": providerId,
      "appointment_time": appointmentTime,
      "status": status,
      "notes": notes,
      "user_contact_email": userContactEmail,
      "user_contact_phone": userContactPhone,
      "provider_contact_email": providerContactEmail,
      "provider_contact_phone": providerContactPhone,
      "created_by": createdBy,
      "updated_by": updatedBy,
      "created_at": createdAt,
      "updated_at": updatedAt,
    };
  }
}

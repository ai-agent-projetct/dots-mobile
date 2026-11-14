class AppointmentRequest {
  final String userId;
  final String providerId;
  final String serviceId;

  final String appointmentTime;
  final String notes;
  final String userName;
  final String userContactEmail;
  final String userContactPhone;
  final String providerContactEmail;
  final String providerContactPhone;

  AppointmentRequest({
    required this.userId,
    required this.providerId,
    required this.serviceId,

    required this.appointmentTime,
    required this.notes,
    required this.userName,
    required this.userContactEmail,
    required this.userContactPhone,
    required this.providerContactEmail,
    required this.providerContactPhone,
  });

  Map<String, dynamic> toJson() {
    return {
      "user_id": userId,
      "provider_id": providerId,
      "service_id": serviceId,
      "appointment_time": appointmentTime,
      "notes": notes,
      "user_name": userName,
      "user_contact_email": userContactEmail,
      "user_contact_phone": userContactPhone,
      "provider_contact_email": providerContactEmail,
      "provider_contact_phone": providerContactPhone,
    };
  }
}

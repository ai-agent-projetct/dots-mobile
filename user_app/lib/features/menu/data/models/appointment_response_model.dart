class GetAppointmentsResponseModel {
  final bool status;
  final String message;
  final List<GetAppointment> data;
  final Pagination pagination;

  GetAppointmentsResponseModel({
    required this.status,
    required this.message,
    required this.data,
    required this.pagination,
  });

  factory GetAppointmentsResponseModel.fromJson(Map<String, dynamic> json) {
    return GetAppointmentsResponseModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: List<GetAppointment>.from(
        (json['data'] ?? []).map((x) => GetAppointment.fromJson(x)),
      ),
      pagination: Pagination.fromJson(json['pagination'] ?? {}),
    );
  }
}

class GetAppointment {
  final String appointmentId;
  final String appointmentToken;
  final String userId;
  final String userName;
  final String providerId;
  final String providerName;
  final String serviceId;
  final String serviceName;
  final DateTime appointmentTime;
  final String status;
  final String? notes;
  final String userContactEmail;
  final String userContactPhone;
  final String providerContactEmail;
  final String providerContactPhone;
  final String? createdBy;
  final String? updatedBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  GetAppointment({
    required this.appointmentId,
    required this.appointmentToken,
    required this.userId,
    required this.userName,
    required this.providerId,
    required this.providerName,
    required this.serviceId,
    required this.serviceName,
    required this.appointmentTime,
    required this.status,
    this.notes,
    required this.userContactEmail,
    required this.userContactPhone,
    required this.providerContactEmail,
    required this.providerContactPhone,
    this.createdBy,
    this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GetAppointment.fromJson(Map<String, dynamic> json) {
    return GetAppointment(
      appointmentId: json['appointment_id'] ?? '',
      appointmentToken: json['appointment_token'] ?? '',
      userId: json['user_id'] ?? '',
      userName: json['user_name'] ?? '',
      providerId: json['provider_id'] ?? '',
      providerName: json['provider_name'] ?? '',
      serviceId: json['service_id'] ?? '',
      serviceName: json['service_name'] ?? '',
      appointmentTime:
          DateTime.tryParse(json['appointment_time'] ?? '') ?? DateTime.now(),
      status: json['status'] ?? '',
      notes: json['notes'],
      userContactEmail: json['user_contact_email'] ?? '',
      userContactPhone: json['user_contact_phone'] ?? '',
      providerContactEmail: json['provider_contact_email'] ?? '',
      providerContactPhone: json['provider_contact_phone'] ?? '',
      createdBy: json['created_by'],
      updatedBy: json['updated_by'],
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }
}

class Pagination {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  Pagination({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      totalPages: json['totalPages'] ?? 1,
    );
  }
}

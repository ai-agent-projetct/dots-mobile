class SignUpRequest {
  final String firstName;
  final String lastName;
  final String emailAddress;
  final String password;
  final String phoneNumber;
  final String address;
  final double latitude;
  final double longitude;
  final List<String> services;
  final String idProof;
  final String? gst;

  SignUpRequest({
    required this.firstName,
    required this.lastName,
    required this.emailAddress,
    required this.password,
    required this.phoneNumber,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.services,
    required this.idProof,
    this.gst,
  });

  /// Convert model to JSON (for API request)
  Map<String, dynamic> toJson() {
    return {
      "First_name": firstName,
      "Last_name": lastName,
      "Email_Address": emailAddress,
      "Password": password,
      "Phone_number": phoneNumber,
      "Address": address,
      "Latitude": latitude,
      "Longitude": longitude,
      "services": services,
      "ID_Proof": idProof,
      "gst": gst,
    };
  }
}

class SignupRequest {
  final String email;
  final String phoneNumber;
  final String role;
  final String password;
  final String deviceId;

  SignupRequest({
    required this.email,
    required this.phoneNumber,
    required this.role,
    required this.password,
    required this.deviceId,
  });

  factory SignupRequest.fromJson(Map<String, dynamic> json) {
    return SignupRequest(
      email: json['email'],
      phoneNumber: json['phone_number'],
      role: json['role'],
      password: json['password'],
      deviceId: json['device_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'phone_number': phoneNumber,
      'role': role,
      'password': password,
      'device_id': deviceId,
    };
  }
}
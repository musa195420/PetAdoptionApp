class LoginResponse {
  final String message;
  final String accessToken;
  final String refreshToken;

  // Constructor
  LoginResponse({
    required this.message,
    required this.accessToken,
    required this.refreshToken,
  });

  // From JSON
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      message: json['message'],
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }
}

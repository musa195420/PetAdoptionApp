class LoginResponse {
  final String message;
  final String accessToken;
  final String refreshToken;
  final String expiresIn; // New field

  // Constructor
  LoginResponse({
    required this.message,
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn, // Include in constructor
  });

  // From JSON
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      message: json['message'],
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      expiresIn: json['expiresIn'], // Parse from JSON
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'expiresIn': expiresIn, // Include in output
    };
  }
}
class LoginRequest {
  String email;
  String password;

  // Constructor
  LoginRequest({required this.email, required this.password});

  // From JSON
  factory LoginRequest.fromJson(Map<String, dynamic> json) {
    return LoginRequest(
      email: json['email'],
      password: json['password'],
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}
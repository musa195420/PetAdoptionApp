class UserInfoRequest {
  final String email;

  // Constructor
  UserInfoRequest({required this.email});

  // From JSON
  factory UserInfoRequest.fromJson(Map<String, dynamic> json) {
    return UserInfoRequest(
      email: json['email'],
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}
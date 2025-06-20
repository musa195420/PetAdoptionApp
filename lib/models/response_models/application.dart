class Application {
  final String? applicationId;
  final String? userId;
  final String? profession;
  final String? reason;
  final String? verificationStatus;

  Application({
    this.applicationId,
    this.userId,
    this.profession,
    this.reason,
    this.verificationStatus,
  });

  factory Application.fromJson(Map<String, dynamic> json) {
    return Application(
      applicationId: json['application_id'],
      userId: json['user_id'],
      profession: json['profession'],
      reason: json['reason'],
      verificationStatus: json['verification_status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (applicationId != null) data['application_id'] = applicationId;
    if (userId != null) data['user_id'] = userId;
    if (profession != null) data['profession'] = profession;
    if (reason != null) data['reason'] = reason;
    if (verificationStatus != null) {
      data['verification_status'] = verificationStatus;
    }
    return data;
  }
}

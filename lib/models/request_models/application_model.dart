import 'package:petadoption/models/hive_models/user.dart';

class ApplicationModel {
  String? verificationStatus;
  String? applicationId;
  String? userId;
  String? profession;
  String? reason;
  String? createdAt;
  String? meetupId; // New field
  User? user;

  ApplicationModel({
    this.applicationId,
    this.userId,
    this.profession,
    this.reason,
    this.verificationStatus,
    this.createdAt,
    this.meetupId,
  });

  factory ApplicationModel.fromJson(Map<String, dynamic> json) {
    return ApplicationModel(
      applicationId: json['application_id'] as String?,
      userId: json['user_id'] as String?,
      profession: json['profession'] as String?,
      reason: json['reason'] as String?,
      verificationStatus: json['verification_status'] as String?,
      createdAt: json['created_at'] as String?,
      meetupId: json['meetup_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (applicationId != null) data['application_id'] = applicationId;
    if (userId != null) data['user_id'] = userId;
    if (profession != null) data['profession'] = profession;
    if (reason != null) data['reason'] = reason;
    if (verificationStatus != null)
      data['verification_status'] = verificationStatus;
    if (createdAt != null) data['created_at'] = createdAt;
    if (meetupId != null) data['meetup_id'] = meetupId;
    return data;
  }

  /// Normal copyWith
  ApplicationModel copyWith({
    String? applicationId,
    String? userId,
    String? profession,
    String? reason,
    String? verificationStatus,
    String? createdAt,
    String? meetupId,
  }) {
    return ApplicationModel(
      applicationId: applicationId ?? this.applicationId,
      userId: userId ?? this.userId,
      profession: profession ?? this.profession,
      reason: reason ?? this.reason,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      createdAt: createdAt ?? this.createdAt,
      meetupId: meetupId ?? this.meetupId,
    );
  }

  /// Copy from another instance (non-null values only)
  ApplicationModel copyWithModel(ApplicationModel other) {
    return ApplicationModel(
      applicationId: other.applicationId ?? this.applicationId,
      userId: other.userId ?? this.userId,
      profession: other.profession ?? this.profession,
      reason: other.reason ?? this.reason,
      verificationStatus: other.verificationStatus ?? this.verificationStatus,
      createdAt: other.createdAt ?? this.createdAt,
      meetupId: other.meetupId ?? this.meetupId,
    );
  }
}

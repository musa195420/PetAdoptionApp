class ReceiverModel {
  final String userId;
  final String? email;
  final String? phoneNumber;
  final String? role;
  final String? deviceId;
  final DateTime? createdAt;
  final String? profileImage;
  final String? name;
  final String? location;
  final bool? isActive;
  final bool? isVerified;

  ReceiverModel(
      {required this.userId,
      this.email,
      this.phoneNumber,
      this.role,
      this.deviceId,
      this.createdAt,
      this.profileImage,
      this.name,
      this.location,
      this.isActive,
      this.isVerified = false});

  factory ReceiverModel.fromJson(Map<String, dynamic> json) {
    return ReceiverModel(
        userId: json['user_id'],
        email: json['email'],
        phoneNumber: json['phone_number'],
        role: json['role'],
        deviceId: json['device_id'],
        createdAt: json['created_at'] != null
            ? DateTime.tryParse(json['created_at'])
            : null,
        profileImage: json['profile_image'],
        name: json['name'],
        location: json['location'],
        isActive: json['is_active'],
        isVerified: json['verified']);
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      if (email != null) 'email': email,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (role != null) 'role': role,
      if (deviceId != null) 'device_id': deviceId,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (profileImage != null) 'profile_image': profileImage,
      if (name != null) 'name': name,
      if (location != null) 'location': location,
      if (isActive != null) 'is_active': isActive,
      if (isVerified != null) 'verified': isVerified
    };
  }
}

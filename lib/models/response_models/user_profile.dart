class UserProfile {
  final String? adopterId;
  final String? donorId;
  final String name;
  final String location;
  final bool isActive;
  String? phonenumber;

  UserProfile({
    this.adopterId,
    this.donorId,
    required this.name,
    required this.location,
    required this.isActive,
    this.phonenumber,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      adopterId: json['adopter_id'],
      donorId: json['donor_id'],
      name: json['name'],
      location: json['location'],
      isActive: json['is_active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (adopterId != null) 'adopter_id': adopterId,
      if (donorId != null) 'donor_id': donorId,
      'name': name,
      'location': location,
      'is_active': isActive,
    };
  }
}

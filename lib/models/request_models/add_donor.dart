class AddDonor {
  final String donorId;
  final String name;
  final String location;
  final bool isActive;
  AddDonor({
    required this.donorId,
    required this.name,
    required this.location,
        required this.isActive,
  });

  factory AddDonor.fromJson(Map<String, dynamic> json) {
    return AddDonor(
      donorId: json['donor_id'] as String,
      name: json['name'] as String,
      location: json['location'] as String,
            isActive: json['is_active'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'donor_id': donorId,
      'name': name,
      'location': location,
        'is_active':isActive,
    };
  }
}
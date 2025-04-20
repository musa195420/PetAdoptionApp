class AddAdopter {
  final String adopterId;
  final String name;
  final String location;
  final bool isActive;

  AddAdopter({
    required this.adopterId,
    required this.name,
    required this.location,
    required this.isActive,
  });

  factory AddAdopter.fromJson(Map<String, dynamic> json) {
    return AddAdopter(
      adopterId: json['adopter_id'] as String,
      name: json['name'] as String,
      location: json['location'] as String,
      isActive: json['is_active'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'adopter_id': adopterId,
      'name': name,
      'location': location,
      'is_active':isActive,
    };
  }
}
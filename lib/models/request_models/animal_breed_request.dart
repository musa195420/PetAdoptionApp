class GetAnimal {
  String id;

  GetAnimal({required this.id});

  // Factory constructor to create an object from JSON
  factory GetAnimal.fromJson(Map<String, dynamic> json) {
    return GetAnimal(
      id: json['animal_id'],
    );
  }

  // Method to convert an object to JSON
  Map<String, dynamic> toJson() {
    return {
      'animal_id': id,
    };
  }
}
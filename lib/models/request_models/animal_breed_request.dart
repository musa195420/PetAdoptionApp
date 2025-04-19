class GetAnimalBreed {
  String id;

  GetAnimalBreed({required this.id});

  // Factory constructor to create an object from JSON
  factory GetAnimalBreed.fromJson(Map<String, dynamic> json) {
    return GetAnimalBreed(
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
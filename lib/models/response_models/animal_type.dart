class AnimalType {
  final String animalId;
  final String name;

  AnimalType({required this.animalId, required this.name});

  factory AnimalType.fromJson(Map<String, dynamic> json) {
    return AnimalType(
      animalId: json['animal_id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'animal_id': animalId,
      'name': name,
    };
  }
}
class BreedType {
  final String animalId;
  final String name;

  BreedType({required this.animalId, required this.name});

  factory BreedType.fromJson(Map<String, dynamic> json) {
    return BreedType(
      animalId: json['breed_id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'breed_id': animalId,
      'name': name,
    };
  }
}
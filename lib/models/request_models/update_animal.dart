class UpdateAnimal {
  final String animalId;
  final String name;

  UpdateAnimal({
    required this.animalId,
    required this.name,
  });

  factory UpdateAnimal.fromJson(Map<String, dynamic> json) {
    return UpdateAnimal(
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

class AddAnimalBreed {
  final String animalId;
  final String name;

  AddAnimalBreed({required this.animalId, required this.name});

  factory AddAnimalBreed.fromJson(Map<String, dynamic> json) {
    return AddAnimalBreed(
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
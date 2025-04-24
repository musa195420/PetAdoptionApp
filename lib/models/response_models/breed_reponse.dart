class BreedResponse {
  final String breedId;
  final String animalId;
  final String name;
  final String? animal;

  BreedResponse({
    required this.breedId,
    required this.animalId,
    required this.name,
    this.animal,
  });

  factory BreedResponse.fromJson(Map<String, dynamic> json) {
    return BreedResponse(
      breedId: json['breed_id'],
      animalId: json['animal_id'],
      name: json['name'],
      animal: json['animal'], // can be null
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'breed_id': breedId,
      'animal_id': animalId,
      'name': name,
    };

    if (animal != null) {
      data['animal'] = animal;
    }

    return data;
  }
}

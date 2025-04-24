class UpdateBreed {
  final String breedId;
   final String animalId;
  final String name;

  UpdateBreed( {required this.animalId,
    required this.breedId,
    required this.name,
  });

  factory UpdateBreed.fromJson(Map<String, dynamic> json) {
    return UpdateBreed(
      animalId:json['animal_id'],
      breedId: json['breed_id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'animal_id':animalId,
      'breed_id': breedId,
      'name': name,
    };
  }
}

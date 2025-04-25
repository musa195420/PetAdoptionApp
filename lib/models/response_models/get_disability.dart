class Disability {
  final String disabilityId;
  String? animalId;
  String? name;
  String? description;
  String? animal;

  Disability({
    required this.disabilityId,
    this.animalId,
    this.name,
    this.description,
    this.animal,
  });

  factory Disability.fromJson(Map<String, dynamic> json) {
    return Disability(
      disabilityId: json['disability_id'],
      animalId: json['animal_id'],
      name: json['name'],
      description: json['description'],
      animal: json['animal'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'disability_id': disabilityId,
      if (animalId != null) 'animal_id': animalId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (animal != null) 'animal': animal,
    };
  }
}

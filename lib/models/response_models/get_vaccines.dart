class Vaccine {
  final String vaccineId;
  String? animalId;
  String? name;
  String? description;
  String? animal;

  Vaccine({
    required this.vaccineId,
    this.animalId,
    this.name,
    this.description,
    this.animal,
  });

  factory Vaccine.fromJson(Map<String, dynamic> json) {
    return Vaccine(
      vaccineId: json['vaccine_id'],
      animalId: json['animal_id'],
      name: json['name'],
      description: json['description'],
      animal: json['animal'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vaccine_id': vaccineId,
      if (animalId != null) 'animal_id': animalId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (animal != null) 'animal': animal,
    };
  }
}

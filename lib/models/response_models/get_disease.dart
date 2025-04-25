class Disease {
  final String diseaseId;
  String? animalId;
  String? name;
  String? description;
  String? animal;

  Disease({
    required this.diseaseId,
    this.animalId,
    this.name,
    this.description,
    this.animal,
  });

  factory Disease.fromJson(Map<String, dynamic> json) {
    return Disease(
      diseaseId: json['disease_id'],
      animalId: json['animal_id'],
      name: json['name'],
      description: json['description'],
      animal: json['animal'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'disease_id': diseaseId,
      if (animalId != null) 'animal_id': animalId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (animal != null) 'animal': animal,
    };
  }
}

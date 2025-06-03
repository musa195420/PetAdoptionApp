class PetHealthInfo {
  final String petId; // non-null
  final String? healthId;
  final String? petName;
  final String? animalId;
  final String? animalName;
  final String? vaccinationId;
  final String? vaccinationName;
  final String? diseaseId;
  final String? diseaseName;
  final String? disabilityId;
  final String? disabilityName;

  PetHealthInfo({
    required this.petId,
    this.healthId,
    this.petName,
    this.animalId,
    this.animalName,
    this.vaccinationId,
    this.vaccinationName,
    this.diseaseId,
    this.diseaseName,
    this.disabilityId,
    this.disabilityName,
  });

  factory PetHealthInfo.fromJson(Map<String, dynamic> json) {
    return PetHealthInfo(
      petId: json['pet_id'] ?? '', // default empty string if null
      healthId: json['health_id'],
      petName: json['pet_name'],
      animalId: json['animal_id'],
      animalName: json['animal_name'],
      vaccinationId: json['vaccination_id'],
      vaccinationName: json['vaccination_name'],
      diseaseId: json['disease_id'],
      diseaseName: json['disease_name'],
      disabilityId: json['disability_id'],
      disabilityName: json['disability_name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'pet_id': petId,
    };
    if (healthId != null) data['health_id'] = healthId;
    if (petName != null) data['pet_name'] = petName;
    if (animalId != null) data['animal_id'] = animalId;
    if (animalName != null) data['animal_name'] = animalName;
    if (vaccinationId != null) data['vaccination_id'] = vaccinationId;
    if (vaccinationName != null) data['vaccination_name'] = vaccinationName;
    if (diseaseId != null) data['disease_id'] = diseaseId;
    if (diseaseName != null) data['disease_name'] = diseaseName;
    if (disabilityId != null) data['disability_id'] = disabilityId;
    if (disabilityName != null) data['disability_name'] = disabilityName;
    return data;
  }
}

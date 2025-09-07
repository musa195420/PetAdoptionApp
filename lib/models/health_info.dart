class HealthInfoModel {
  String? healthId;
  String petId;
  String? vaccinationId;
  String? diseaseId;
  String? disabilityId;
  String? animalId;

  HealthInfoModel({
    required this.petId,
    this.healthId,
    this.vaccinationId,
    this.diseaseId,
    this.disabilityId,
    this.animalId,
  });

  factory HealthInfoModel.fromJson(Map<String, dynamic> json) {
    return HealthInfoModel(
      petId: json['pet_id'],
      vaccinationId: json['vaccination_id'],
      diseaseId: json['disease_id'],
      disabilityId: json['disability_id'],
      healthId: json['health_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (petId != null) data['pet_id'] = petId;
    if (vaccinationId != null) data['vaccination_id'] = vaccinationId;
    if (diseaseId != null) data['disease_id'] = diseaseId;
    if (disabilityId != null) data['disability_id'] = disabilityId;
    if (healthId != null) data['health_id'] = healthId;
    return data;
  }
}

class HealthInfoModel{

   String petId;
   String? vaccinationId;
   String? diseaseId;
   String? disabilityId;
   String? animalId;

  HealthInfoModel({
    required this.petId,
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
     
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pet_id': petId,
      'vaccination_id': vaccinationId,
      'disease_id': diseaseId,
      'disability_id': disabilityId,
     
    };
  }


}
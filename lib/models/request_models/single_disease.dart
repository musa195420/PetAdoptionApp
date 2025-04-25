class SingleDisease {
  final String diseaseId;
  
  SingleDisease({
    required this.diseaseId,
  
  });

  factory SingleDisease.fromJson(Map<String, dynamic> json) {
    return SingleDisease(
      diseaseId: json['disease_id'],

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'disease_id': diseaseId,
   
    };
  }
}
class SingleDisability {
  final String disabilityId;
  
  SingleDisability({
    required this.disabilityId,
  
  });

  factory SingleDisability.fromJson(Map<String, dynamic> json) {
    return SingleDisability(
      disabilityId: json['disability_id'],

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vaccine_id': disabilityId,
   
    };
  }
}
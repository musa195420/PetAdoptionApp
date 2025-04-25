class SingleVaccine {
  final String vaccineId;
  
  SingleVaccine({
    required this.vaccineId,
  
  });

  factory SingleVaccine.fromJson(Map<String, dynamic> json) {
    return SingleVaccine(
      vaccineId: json['vaccine_id'],

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vaccine_id': vaccineId,
   
    };
  }
}
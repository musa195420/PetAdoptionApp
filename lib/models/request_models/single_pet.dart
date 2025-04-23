class SinglePet {
  String petId;

  // Constructor
  SinglePet({required this.petId});

  // From JSON to SinglePet instance
  factory SinglePet.fromJson(Map<String, dynamic> json) {
    return SinglePet(
      petId: json['pet_id'],
    );
  }

  // From SinglePet instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'pet_id': petId,
    };
  }
}

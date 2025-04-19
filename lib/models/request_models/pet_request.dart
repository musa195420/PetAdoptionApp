class PetRequest {
  final String donorId;
  final String name;
  final String animalType;
  final bool isLive;
  final String breedId;
  final int age;
  final String gender;
  final String description;

    String ?petId;

  PetRequest({
    required this.donorId,
    required this.name,
    required this.animalType,
    required this.isLive,
    required this.breedId,
    required this.age,
    required this.gender,
    required this.description,
    this.petId,
  });

  factory PetRequest.fromJson(Map<String, dynamic> json) {
    return PetRequest(
      donorId: json['donor_id'],
      name: json['name'],
      animalType: json['animal_type'],
      isLive: json['is_live'],
      breedId: json['breed_id'],
      age: json['age'],
      gender: json['gender'],
      description: json['description'],
      petId: json['pet_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'donor_id': donorId,
      'name': name,
      'animal_type': animalType,
      'is_live': isLive,
      'breed_id': breedId,
      'age': age,
      'gender': gender,
      'description': description,

    };
  }
}
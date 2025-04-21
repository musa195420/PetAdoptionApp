class PetResponse {
  final String petId;
  final String donorId;
  final String breedId;
  final String animalId;
  final String? name;
  final int? age;
  final String? gender;
  final String? description;
  final String? isApproved;
  final String? rejectionReason;
  final bool? isLive;
  final String? createdAt;
  final String? image;
  final String? animal;
  final String? breed;

  PetResponse({
    required this.petId,
    required this.donorId,
    required this.breedId,
    required this.animalId,
    this.name,
    this.age,
    this.gender,
    this.description,
    this.isApproved,
    this.rejectionReason,
    this.isLive,
    this.createdAt,
    this.image,
    this.animal,
    this.breed,
  });

  factory PetResponse.fromJson(Map<String, dynamic> json) {
    return PetResponse(
      petId: json['pet_id'],
      donorId: json['donor_id'],
      breedId: json['breed_id'],
      animalId: json['animal_id'],
      name: json['name'],
      age: json['age'],
      gender: json['gender'],
      description: json['description'],
      isApproved: json['is_approved'],
      rejectionReason: json['rejection_reason'],
      isLive: json['is_live'],
      createdAt: json['created_at'],
      image: json['image'],
      animal: json['animal'],
      breed: json['breed'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pet_id': petId,
      'donor_id': donorId,
      'breed_id': breedId,
      'animal_id': animalId,
      'name': name,
      'age': age,
      'gender': gender,
      'description': description,
      'is_approved': isApproved,
      'rejection_reason': rejectionReason,
      'is_live': isLive,
      'created_at': createdAt,
      'image': image,
      'animal': animal,
      'breed': breed,
    };
  }
}

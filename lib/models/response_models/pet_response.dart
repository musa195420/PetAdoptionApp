class PetResponse {
   String petId;
   String donorId;
   String breedId;
   String animalId;
   String? name;
   int? age;
   String? gender;
   String? description;
   String? isApproved;
   String? rejectionReason;
   bool? isLive;
   String? createdAt;
   String? image;
   String? animal;
   String? breed;
   String? userEmail;
     String? location;

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
    this.userEmail,
    this.location,
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
      userEmail: json['user_email'],
      location: json['location']
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
      'user_email': userEmail,
      'location':location,
    };
  }
}

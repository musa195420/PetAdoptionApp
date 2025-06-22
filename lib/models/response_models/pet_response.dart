class PetResponse {
  String? petId;
  String? donorId;
  String? breedId;
  String? animalId;
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
    this.petId,
    this.donorId,
    this.breedId,
    this.animalId,
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
        location: json['location']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (petId != null) data['pet_id'] = petId;
    if (donorId != null) data['donor_id'] = donorId;
    if (breedId != null) data['breed_id'] = breedId;
    if (animalId != null) data['animal_id'] = animalId;
    if (name != null) data['name'] = name;
    if (age != null) data['age'] = age;
    if (gender != null) data['gender'] = gender;
    if (description != null) data['description'] = description;
    if (isApproved != null) data['is_approved'] = isApproved;
    if (rejectionReason != null) data['rejection_reason'] = rejectionReason;
    if (isLive != null) data['is_live'] = isLive;
    if (createdAt != null) data['created_at'] = createdAt;
    if (image != null) data['image'] = image;
    if (animal != null) data['animal'] = animal;
    if (breed != null) data['breed'] = breed;
    if (userEmail != null) data['user_email'] = userEmail;
    if (location != null) data['location'] = location;
    return data;
  }
}

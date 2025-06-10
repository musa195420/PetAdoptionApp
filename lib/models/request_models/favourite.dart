import '../response_models/pet_response.dart';

class Favourite {
  String? favouriteId; // maps to 'fav_id'
  String? userId;
  String? petId;
  List<String>? favPets;
  PetResponse? pet; // New: nested pet object

  Favourite({
    this.favouriteId,
    this.userId,
    this.petId,
    this.favPets,
    this.pet,
  });

  factory Favourite.fromJson(Map<String, dynamic> json) {
    return Favourite(
      favouriteId: json['fav_id'] as String?,
      userId: json['user_id'] as String?,
      petId: json['pet_id'] as String?,
      favPets: (json['fav_pets'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      pet: json['pet'] != null ? PetResponse.fromJson(json['pet']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (favouriteId != null) data['fav_id'] = favouriteId;
    if (userId != null) data['user_id'] = userId;
    if (petId != null) data['pet_id'] = petId;
    if (favPets != null) data['fav_pets'] = favPets;
    if (pet != null) data['pet'] = pet!.toJson();
    return data;
  }
}

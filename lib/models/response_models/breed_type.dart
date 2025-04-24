class BreedType {
  final String breedId;
  final String name;

  BreedType({required this.breedId, required this.name});

  factory BreedType.fromJson(Map<String, dynamic> json) {
    return BreedType(
      breedId: json['breed_id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'breed_id': breedId,
    };
  }
}
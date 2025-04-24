class AddAnimalBreed {
  final String? animalId;
  final String? name;
  final List<AddAnimalBreed>? names;

  AddAnimalBreed({this.animalId, this.name, this.names});

  factory AddAnimalBreed.fromJson(Map<String, dynamic> json) {
    return AddAnimalBreed(
      animalId: json['animal_id'],
      name: json['name'],
      names: json['names'] != null
          ? List<AddAnimalBreed>.from(json['names'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    if (name != null) {
      return <String, dynamic>{
        'animal_id': animalId,
        'name': name,
      };
    } else {
      return <String, dynamic>{'breeds': names};
    }
  }
}

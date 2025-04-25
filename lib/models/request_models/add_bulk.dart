class AddInBulk {
  final String? animalId;
  final String? name;
 String? description;
  final List<AddInBulk>? names;

  AddInBulk({this.animalId, this.name, this.names,this.description});

  factory AddInBulk.fromJson(Map<String, dynamic> json) {
    return AddInBulk(
      animalId: json['animal_id'],
      name: json['name'],
      names: json['names'] != null
          ? List<AddInBulk>.from(json['names'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    if (name != null) {
      return <String, dynamic>{
        'animal_id': animalId,
        'name': name,
        'description':description,
      };
    } else {
      return <String, dynamic>{'vaccinations': names};
    }
  }
  
 Map<String, dynamic> toJsonDiseases() {
    if (name != null) {
      return <String, dynamic>{
        'animal_id': animalId,
        'name': name,
        'description':description,
      };
    } else {
      return <String, dynamic>{'diseases': names};
    }
  }

  
 Map<String, dynamic> toJsonDiability() {
    if (name != null) {
      return <String, dynamic>{
        'animal_id': animalId,
        'name': name,
        'description':description,
      };
    } else {
      return <String, dynamic>{'disabilities': names};
    }
  }
}


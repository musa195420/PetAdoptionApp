// ignore_for_file: file_names

class AddAnimalType {
  String? name;
  List<String>? names;

  AddAnimalType({ this.name,this.names});

  // Factory constructor to create an object from JSON
  factory AddAnimalType.fromJson(Map<String, dynamic> json) {
    return AddAnimalType(
      name: json['name'],
      names:json['animals'],
    );
  }

  // Method to convert an object to JSON
 Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = {};
  if (name != null) data['name'] = name;
  if (names != null) data['animals'] = names;
  return data;
}
}
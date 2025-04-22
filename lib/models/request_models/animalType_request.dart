// ignore_for_file: file_names

class AddAnimalType {
  String name;

  AddAnimalType({required this.name});

  // Factory constructor to create an object from JSON
  factory AddAnimalType.fromJson(Map<String, dynamic> json) {
    return AddAnimalType(
      name: json['name'],
    );
  }

  // Method to convert an object to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}
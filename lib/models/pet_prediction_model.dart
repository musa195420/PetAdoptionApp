class PetPrediction {
  final String type;
  final double confidence;
  final String imagePath;

  PetPrediction({
    required this.type,
    required this.confidence,
    required this.imagePath,
  });

  factory PetPrediction.fromMap(Map<String, dynamic> map, String imagePath) {
    // Assuming your map has something like:
    // "Animal" -> "Dog"
    // "Confidence" -> "0.252%"
    return PetPrediction(
      type: map['Animal'] ?? '',
      confidence: _parseConfidence(map['Confidence']),
      imagePath: imagePath,
    );
  }

  static double _parseConfidence(dynamic value) {
    if (value == null) return 0.0;
    String str = value.toString().replaceAll('%', '');
    return double.tryParse(str) ?? 0.0;
  }
}

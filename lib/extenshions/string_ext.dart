// string_extensions.dart

extension StringExtensions on String {
  String toCamelCase() {
    if (isEmpty) return this;

    final words = trim().toLowerCase().split(RegExp(r'[\s_\-]+'));

    if (words.isEmpty) return this;

    return words.first +
        words
            .skip(1)
            .map((word) => word[0].toUpperCase() + word.substring(1))
            .join();
  }

  String toTitleCase() {
    if (isEmpty) return this;
    final trimmed = trim();
    if (trimmed.length == 1) return trimmed.toUpperCase();
    return trimmed[0].toUpperCase() + trimmed.substring(1).toLowerCase();
  }
}

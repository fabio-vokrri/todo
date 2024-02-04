extension StringExtensions on String {
  String get capitalized {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

extension CapExtension on String {
  String get inCaps => '${this[0].toUpperCase()}${this.substring(1)}';

  String get inSmallCaps => '${this[0].toLowerCase()}${this.substring(1)}';

  String get allInCaps => this.toUpperCase();

  String get capitalizeFirstOfEach =>
      this.split(" ").map((str) => str.inCaps).join(" ");
}

/// Display Pokemon ID with left-padded zeroes.
/// e.g. 001, 015, 324
/// As of this writing, there are 898 Pokemon, so idWidth = 3.
String formatPokemonId(int id) {
  int idWidth = 3;
  return id.toString().padLeft(idWidth, '0');
}

/// Formats the Pokemon's move name returned by the API.
/// e.g. razor-wind' becomes 'Razor Wind'.
String formatPokemonMoveName(String moveName) {
  final words = moveName.split('-').map((e) => e.inCaps).toList();
  final formattedMoveName = words.join(' ');
  return formattedMoveName;
}
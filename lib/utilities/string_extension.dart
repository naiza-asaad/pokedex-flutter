extension CapExtension on String {
  String get inCaps => '${this[0].toUpperCase()}${this.substring(1)}';

  String get inSmallCaps => '${this[0].toLowerCase()}${this.substring(1)}';

  String get allInCaps => this.toUpperCase();

  String get capitalizeFirstofEach =>
      this.split(" ").map((str) => str.inCaps).join(" ");
}

/// Display Pokemon ID with left-padded zeroes.
/// e.g. 0001, 0015, 0324
/// As of this writing, there are 898 Pokemon, so idWidth = 3.
String formatPokemonId(int id) {
  int idWidth = 3;
  return id.toString().padLeft(idWidth, '0');
}

class PokemonMove {
  String name;
  String url;

  PokemonMove({
    this.name,
    this.url,
  });

  factory PokemonMove.fromJson(Map<String, dynamic> parsedJson) {
    return PokemonMove(
      name: parsedJson['move']['name'],
      url: parsedJson['move']['url'],
    );
  }
}

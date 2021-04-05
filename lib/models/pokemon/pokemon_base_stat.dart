class PokemonBaseStat {
  int baseStat;
  String name;
  String detailsUrl;

  PokemonBaseStat({
    this.baseStat,
    this.name,
    this.detailsUrl,
  });

  factory PokemonBaseStat.fromJson(Map<String, dynamic> parsedJson) {
    return PokemonBaseStat(
      baseStat: parsedJson['base_stat'],
      name: parsedJson['stat']['name'],
      detailsUrl: parsedJson['stat']['url'],
    );
  }

  @override
  String toString() {
    return 'name=$name, stat=$baseStat, url=$detailsUrl';
  }
}

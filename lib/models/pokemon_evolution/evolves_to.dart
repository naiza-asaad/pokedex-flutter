class EvolvesTo {
  String pokemonName;
  List<EvolvesTo> evolutions;
  String imageUrl;
  int pokemonId;

  EvolvesTo({
    this.pokemonName,
    this.evolutions,
  });

  factory EvolvesTo.fromJson(Map<String, dynamic> parsedJson) {
    var tempEvolutionsList = parsedJson['evolves_to'] as List;
    if (tempEvolutionsList.length == 0) {
      return EvolvesTo(
        pokemonName: parsedJson['species']['name'],
        evolutions: [],
      );
    } else {
      List<EvolvesTo> evolutionsList =
          tempEvolutionsList.map((e) => EvolvesTo.fromJson(e)).toList();
      return EvolvesTo(
        pokemonName: parsedJson['species']['name'],
        evolutions: evolutionsList,
      );
    }
  }

  @override
  String toString() {
    return 'species name=$pokemonName';
  }
}

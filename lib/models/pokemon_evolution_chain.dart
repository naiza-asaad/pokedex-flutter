
class PokemonEvolutionChain {
  EvolvesTo evolutionChain;

  PokemonEvolutionChain({
    this.evolutionChain,
  });

  factory PokemonEvolutionChain.fromJson(Map<String, dynamic> parsedJson) {
    print('did i make it here?');
    return PokemonEvolutionChain(
      evolutionChain: EvolvesTo.fromJson(parsedJson['chain']),
    );
  }

  @override
  String toString() {
    return 'evolution chain = $evolutionChain';
  }
}

class EvolvesTo {
  String speciesName;
  List<EvolvesTo> evolutions;

  EvolvesTo({
    this.speciesName,
    this.evolutions,
  });

  factory EvolvesTo.fromJson(Map<String, dynamic> parsedJson) {
    var tempEvolutionsList = parsedJson['evolves_to'] as List;
    if (tempEvolutionsList.length == 0) {
      return EvolvesTo(
        speciesName: parsedJson['species']['name'],
        evolutions: [],
      );
    } else {
      List<EvolvesTo> evolutionsList = tempEvolutionsList.map((e) => EvolvesTo.fromJson(e)).toList();
      return EvolvesTo(
        speciesName: parsedJson['species']['name'],
        evolutions: evolutionsList,
      );
    }
  }

  @override
  String toString() {
    return 'species name=$speciesName';
  }
}
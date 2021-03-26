
class PokemonEvolutionChain {
  EvolvesTo chain;

  PokemonEvolutionChain({
    this.chain,
  });

  factory PokemonEvolutionChain.fromJson(Map<String, dynamic> parsedJson) {
    return PokemonEvolutionChain(
      chain: EvolvesTo.fromJson(parsedJson['chain']),
    );
  }

  @override
  String toString() {
    return 'evolution chain = $chain';
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
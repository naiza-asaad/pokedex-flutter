
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
      List<EvolvesTo> evolutionsList = tempEvolutionsList.map((e) => EvolvesTo.fromJson(e)).toList();
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

class PokemonEvolutionChainV2 {
  EvolvesTo basePokemon;
  List<EvolvesTo> stage2Evolutions;
  List<EvolvesTo> stage3Evolutions;
  bool hasStage2Evolutions;
  bool hasStage3Evolutions;


  PokemonEvolutionChainV2(PokemonEvolutionChain chain) {
    stage2Evolutions = chain.chain.evolutions;
    hasStage2Evolutions =
        stage2Evolutions != null && stage2Evolutions.isNotEmpty;

    hasStage3Evolutions = hasStage2Evolutions &&
        stage2Evolutions[0].evolutions != null &&
        stage2Evolutions[0].evolutions.isNotEmpty;
    if (hasStage3Evolutions) {
      for (var evolution in stage2Evolutions) {
        for (var stage3Evolution in evolution.evolutions) {
          stage3Evolutions.add(stage3Evolution);
        }
      }
    }
  }
}
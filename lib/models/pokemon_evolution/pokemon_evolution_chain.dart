import 'package:pokedex/models/pokemon_evolution/evolves_to.dart';

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

import 'package:pokedex/models/pokemon_evolution/pokemon_evolution_chain.dart';

import 'api/pokemon_evolution_api.dart';

class PokemonEvolutionService {
  static Future<PokemonEvolutionChain> fetchPokemonEvolutionChainService(
      String speciesUrl) async {
    return await PokemonEvolutionApi.fetchPokemonEvolutionChain(speciesUrl);
  }
}

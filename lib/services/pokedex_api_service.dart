import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/models/pokemon_evolution_chain.dart';
import 'package:pokedex/models/simple_pokemon_list.dart';
import 'package:pokedex/services/pokedex_api_helper.dart';
import 'package:pokedex/utilities/string_extension.dart';

Future<SimplePokemonList> fetchPokemonListService(
    {int offset = 0, int limit = 20}) async {
  SimplePokemonList pokemonList =
      await fetchPokemonListFromApi(limit: limit, offset: offset);
  return pokemonList;
}

Future<List<Pokemon>> fetchPokemonDetailsListService(
    SimplePokemonList pokemonList) async {
  List<Pokemon> pokemonDetailsList =
      await fetchPokemonDetailsListFromApi(pokemonList);
  return pokemonDetailsList;
}

Future<PokemonEvolutionChain> fetchPokemonEvolutionChainService(String speciesUrl) async {
  return await fetchPokemonEvolutionChainFromApi(speciesUrl);
}

Future<Pokemon> fetchPokemonDetailsService({String name, int id}) async {
  final formattedName = name.inSmallCaps;
  return await fetchPokemonDetailsFromApi(name: formattedName, id: id);
}

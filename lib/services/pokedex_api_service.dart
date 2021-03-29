import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/models/pokemon_evolution_chain.dart';
import 'package:pokedex/models/simple_pokemon_list.dart';
import 'package:pokedex/services/pokedex_api_helper.dart';
import 'package:pokedex/utilities/string_extension.dart';

Future<SimplePokemonList> fetchPokemonListService({
  int offset = 0,
  int limit = 20,
}) async {
  SimplePokemonList simplePokemonList = await fetchPokemonListFromApi(
    limit: limit,
    offset: offset,
  );

  final pokemonDetailsList = await fetchPokemonDetailsListService(simplePokemonList);
  simplePokemonList.pokemonList = pokemonDetailsList;
  return simplePokemonList;
}

Future<SimplePokemonList> loadMorePokemonService({
  String nextPageUrl,
  SimplePokemonList oldSimplePokemonList,
}) async {
  print('loadMorePokemonService()');
  SimplePokemonList newSimplePokemonList =
      await fetchPokemonListFromApi(nextPageUrl: nextPageUrl);

  oldSimplePokemonList.simplePokemonList.addAll(newSimplePokemonList.simplePokemonList);
  oldSimplePokemonList.pokemonList.addAll(newSimplePokemonList.pokemonList);
  oldSimplePokemonList.next = newSimplePokemonList.next;
  oldSimplePokemonList.previous = newSimplePokemonList.previous;

  final pokemonDetailsList = await fetchPokemonDetailsListService(newSimplePokemonList);
  oldSimplePokemonList.pokemonList.addAll(pokemonDetailsList);

  return oldSimplePokemonList;
}

Future<List<Pokemon>> fetchSearchPokemonListService(
    String searchedPokemonName) async {
  searchedPokemonName = searchedPokemonName.toLowerCase();
  final searchPokemonList =
      await fetchSearchPokemonListFromApi(searchedPokemonName);
  return searchPokemonList;
}

Future<List<Pokemon>> fetchPokemonDetailsListService(
    SimplePokemonList simplePokemonList) async {
  return await fetchPokemonDetailsListFromApi(simplePokemonList);
}

Future<PokemonEvolutionChain> fetchPokemonEvolutionChainService(
    String speciesUrl) async {
  return await fetchPokemonEvolutionChainFromApi(speciesUrl);
}

Future<Pokemon> fetchPokemonDetailsService({String name, int id}) async {
  final formattedName = name.inSmallCaps;
  return await fetchPokemonDetailsFromApi(name: formattedName, id: id);
}

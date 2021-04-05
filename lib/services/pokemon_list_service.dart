import 'package:pokedex/models/pokemon/pokemon.dart';
import 'package:pokedex/models/simple_pokemon/simple_pokemon_list.dart';

import 'api/pokemon_list_api.dart';

class PokemonListService {
  static Future<SimplePokemonList> fetchPokemonList() async {
    SimplePokemonList simplePokemonList =
        await PokemonListApi.fetchPokemonList();

    final pokemonDetailsList = await _fetchPokemonDetailsList(simplePokemonList);
    simplePokemonList.pokemonList = pokemonDetailsList;
    return simplePokemonList;
  }

  static Future<SimplePokemonList> loadMorePokemon({
    String nextPageUrl,
    SimplePokemonList oldSimplePokemonList,
  }) async {
    SimplePokemonList newSimplePokemonList =
        await PokemonListApi.fetchPokemonList(nextPageUrl: nextPageUrl);

    oldSimplePokemonList.simplePokemonList
        .addAll(newSimplePokemonList.simplePokemonList);
    oldSimplePokemonList.pokemonList.addAll(newSimplePokemonList.pokemonList);
    oldSimplePokemonList.next = newSimplePokemonList.next;
    oldSimplePokemonList.previous = newSimplePokemonList.previous;

    final pokemonDetailsList =
        await _fetchPokemonDetailsList(newSimplePokemonList);
    oldSimplePokemonList.pokemonList.addAll(pokemonDetailsList);

    return oldSimplePokemonList;
  }

  static Future<List<Pokemon>> _fetchPokemonDetailsList(
      SimplePokemonList simplePokemonList) async {
    return await PokemonListApi.fetchPokemonDetailsList(simplePokemonList);
  }
}

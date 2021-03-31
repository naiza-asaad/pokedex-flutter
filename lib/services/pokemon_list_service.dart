
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/models/simple_pokemon_list.dart';

import 'api/pokemon_list_api.dart';

class PokemonListService {
  Future<SimplePokemonList> fetchPokemonList() async {
    SimplePokemonList simplePokemonList = await PokemonListApi.fetchPokemonList();

    final pokemonDetailsList =
    await fetchPokemonDetailsList(simplePokemonList);
    simplePokemonList.pokemonList = pokemonDetailsList;
    return simplePokemonList;
  }

  Future<SimplePokemonList> loadMorePokemon({
    String nextPageUrl,
    SimplePokemonList oldSimplePokemonList,
  }) async {
    print('loadMorePokemon()');
    SimplePokemonList newSimplePokemonList =
    await PokemonListApi.fetchPokemonList(nextPageUrl: nextPageUrl);

    oldSimplePokemonList.simplePokemonList
        .addAll(newSimplePokemonList.simplePokemonList);
    oldSimplePokemonList.pokemonList.addAll(newSimplePokemonList.pokemonList);
    oldSimplePokemonList.next = newSimplePokemonList.next;
    oldSimplePokemonList.previous = newSimplePokemonList.previous;

    final pokemonDetailsList =
    await fetchPokemonDetailsList(newSimplePokemonList);
    oldSimplePokemonList.pokemonList.addAll(pokemonDetailsList);

    return oldSimplePokemonList;
  }

  Future<List<Pokemon>> fetchPokemonDetailsList(
      SimplePokemonList simplePokemonList) async {
    return await PokemonListApi.fetchPokemonDetailsList(simplePokemonList);
  }
}
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/utilities/string_extension.dart';

import 'api/pokemon_api.dart';

class PokemonService {
  Future<List<Pokemon>> fetchSearchPokemonList(
      String searchedPokemonName) async {
    searchedPokemonName = searchedPokemonName.toLowerCase();
    final searchPokemonList =
        await PokemonApi.searchPokemon(searchedPokemonName);
    return searchPokemonList;
  }

  Future<Pokemon> fetchPokemonDetails({String name, int id}) async {
    final formattedName = name.inSmallCaps;
    return await PokemonApi.fetchPokemonDetails(name: formattedName, id: id);
  }
}

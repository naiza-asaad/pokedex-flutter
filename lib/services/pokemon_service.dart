import 'package:pokedex/models/pokemon/pokemon.dart';
import 'package:pokedex/utilities/string_extension.dart';

import 'api/pokemon_api.dart';

class PokemonService {
  static Future<List<Pokemon>> fetchSearchPokemonList(
      String searchedPokemonName) async {
    searchedPokemonName = searchedPokemonName.toLowerCase();
    final searchPokemonList =
        await PokemonApi.searchPokemon(searchedPokemonName);
    return searchPokemonList;
  }

  static Future<Pokemon> fetchPokemonDetails({String name, int id}) async {
    final formattedName = name.inSmallCaps;
    return await PokemonApi.fetchPokemonDetails(name: formattedName, id: id);
  }
}

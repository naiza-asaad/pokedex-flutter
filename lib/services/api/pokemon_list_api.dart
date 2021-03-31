import 'package:dio/dio.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/models/simple_pokemon_list.dart';

import 'api_config.dart';

class PokemonListApi {
  /// Fetches Pokemon list that only contains the Pokemon's name and details URL.
  static Future<SimplePokemonList> fetchPokemonList({String nextPageUrl}) async {
    print('fetchPokemonList()');
    try {
      bool hasPaginatedUrl = nextPageUrl != null && nextPageUrl.isNotEmpty;

      final fetchUrl = !hasPaginatedUrl ? initialFetchUrl : nextPageUrl;
      print('fetchUrl=$fetchUrl');
      final response = await dio.get(fetchUrl);
      final pokemonList = SimplePokemonList.fromJson(response.data);
      return pokemonList;
    } catch (e) {
      print(e);
    }
  }

  /// Fetches more details needed to display the main home page list (ID, image, and types).
  static Future<List<Pokemon>> fetchPokemonDetailsList(
      SimplePokemonList simplePokemonList) async {
    print('fetchPokemonDetailsList()');
    try {
      final List<Response> responses =
          await _fetchPokemonDetailsResponses(simplePokemonList);

      // Build list of fetched Pokemon.
      List<Pokemon> pokemonDetailsList = [];
      for (var response in responses) {
        final pokemon = Pokemon.fromJson(response.data);
        pokemonDetailsList.add(pokemon);
      }

      return pokemonDetailsList;
    } catch (e) {
      print(e);
    }
  }

  static Future<List<Response>> _fetchPokemonDetailsResponses(
      SimplePokemonList simplePokemonList) async {
    print('_fetchPokemonDetailsResponses()');

    List<Future<Response>> responses = [];
    for (var i = 0; i < simplePokemonList.simplePokemonList.length; ++i) {
      final fetchUrl = simplePokemonList.simplePokemonList[i].detailsUrl;
      final response = dio.get(fetchUrl);
      responses.add(response);
    }

    var results = await Future.wait(responses);

    return results;
  }
}

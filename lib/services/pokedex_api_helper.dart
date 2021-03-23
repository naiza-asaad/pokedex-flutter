import 'package:pokedex/models/simple_pokemon_list.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:dio/dio.dart';

class PokedexApiHelper {
  static const String _baseUrl = 'https://pokeapi.co/api/v2';

  Future<SimplePokemonList> fetchPokemonList({int offset = 0, int limit = 20}) async {
    try {
      final fetchUrl = '$_baseUrl/pokemon';
      final response = await Dio().get(fetchUrl);
      final pokemonList = SimplePokemonList.fromJson(response.data);

      return pokemonList;
    } catch (e) {
      print(e);
    }
  }

  Future<List<Response>> _fetchPokemonDetailsResponses(SimplePokemonList simplePokemonList) async {
    // Fetch pokemon details using detailsUrl inside each simplePokemon.
    List<Future<Response>> responses = [];
    for (var i = 0; i < simplePokemonList.simplePokemonList.length; ++i) {
      final fetchUrl = simplePokemonList.simplePokemonList[i].detailsUrl;
      final response =  Dio().get(fetchUrl);
      responses.add(response);
    }

    // Combine the results of the concurrent API calls.
    var results = await Future.wait(responses);

    return results;
  }

  Future<List<Pokemon>> fetchPokemonDetailsList(SimplePokemonList pokemonList) async {
    try {
      final List<Response> responses = await _fetchPokemonDetailsResponses(pokemonList);

      // Build list of fetched Pokemon.
      List<Pokemon> pokemonDetailsList = [];
      for (var response in responses) {
        final pokemon = buildPokemonFromResponse(response);
        pokemonDetailsList.add(pokemon);
      }

      // Since the calls were made concurrently, sort the Pokemon in ascending
      // order based on their ID.
      pokemonDetailsList.sort((pokemonA, pokemonB) => pokemonA.id.compareTo(pokemonB.id));

      print('pokemon details');
      print(pokemonDetailsList);

      return pokemonDetailsList;

    } catch (e) {
      print(e);
    }
  }

  Pokemon buildPokemonFromResponse(Response response) {
    return Pokemon.fromJson(response.data);
  }

}

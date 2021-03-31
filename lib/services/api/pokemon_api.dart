import 'package:dio/dio.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/models/pokemon_evolution_chain.dart';
import 'package:pokedex/models/pokemon_species.dart';
import 'package:pokedex/services/api/pokemon_evolution_api.dart';

import 'api_config.dart';

class PokemonApi {
  static const path = '/pokemon';

  static Future<List<Pokemon>> searchPokemon(String pokemonName) async {
    print('searchPokemon())');
    try {
      final fetchUrl = '$baseUrl/$path/$pokemonName';
      print('search pokemon fetchUrl=$fetchUrl');
      final response = await dio.get(fetchUrl);
      final pokemon = Pokemon.fromJson(response.data);
      final List<Pokemon> searchResultList = [];
      searchResultList.add(pokemon);
      return searchResultList;
    } catch (e) {
      if (e is DioError) {
        print(e);
        return [];
      }
    }
  }

  static Future<Pokemon> fetchPokemonDetails({String name, int id}) async {
    print('fetchPokemonDetails)');
    try {
      final fetchPokemonUrl = (name != null && name.isNotEmpty)
          ? '$baseUrl/$path/$name'
          : '$baseUrl/$path/$id';
      print('fetchPokemonUrl=$fetchPokemonUrl');

      // Fetch species details.
      final fetchSpeciesUrl = (name != null && name.isNotEmpty)
          ? '$baseUrl/pokemon-species/$name'
          : '$baseUrl/pokemon-species/$id';
      print('fetchSpeciesUrl=$fetchSpeciesUrl');

      List<Future<Response>> futureResponses = [];
      futureResponses.addAll([
        dio.get(fetchPokemonUrl),
        dio.get(fetchSpeciesUrl),
      ]);
      List<Response> responses = await Future.wait(futureResponses);
      final pokemon = Pokemon.fromJson(responses[0].data);
      final species = PokemonSpecies.fromJson(responses[1].data);
      pokemon.species = species;

      // Fetch evolution chain details
      print('fetching evolution');
      final evolutionChainResponse = await dio.get(species.evolutionChainUrl);
      final evolutionChain =
          PokemonEvolutionChain.fromJson(evolutionChainResponse.data);
      pokemon.evolutionChain = evolutionChain;
      print('fetched evolution');

      // Fetch images for evolution chain.
      await PokemonEvolutionApi.fetchIdAndImagesForEvolutionChain(
          pokemon.evolutionChain);
      return pokemon;
    } catch (e) {
      print(e);
    }
  }
}

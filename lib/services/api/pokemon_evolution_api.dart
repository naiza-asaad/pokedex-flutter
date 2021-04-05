import 'package:dio/dio.dart';
import 'package:pokedex/models/pokemon/pokemon.dart';
import 'package:pokedex/models/pokemon_evolution/evolves_to.dart';
import 'package:pokedex/models/pokemon_evolution/pokemon_evolution_chain.dart';
import 'package:pokedex/models/pokemon_species/pokemon_species.dart';

import 'api_config.dart';

class PokemonEvolutionApi {
  static Future<PokemonEvolutionChain> fetchPokemonEvolutionChain(
      String speciesUrl) async {
    try {
      final speciesResponse = await dio.get(speciesUrl);
      PokemonSpecies pokemonSpecies =
          PokemonSpecies.fromJson(speciesResponse.data);

      final evolutionResponse = await dio.get(pokemonSpecies.evolutionChainUrl);
      PokemonEvolutionChain evolutionChain =
          PokemonEvolutionChain.fromJson(evolutionResponse.data);

      return evolutionChain;
    } catch (e) {
      print(e);
    }
  }

  static Future fetchIdAndImagesForEvolutionChain(
      PokemonEvolutionChain chain) async {
    List<EvolvesTo> stage2Evolutions = chain.chain.evolutions;
    bool hasStage2Evolutions =
        stage2Evolutions != null && stage2Evolutions.isNotEmpty;

    List<EvolvesTo> stage3Evolutions = [];
    bool hasStage3Evolutions = hasStage2Evolutions &&
        stage2Evolutions[0].evolutions != null &&
        stage2Evolutions[0].evolutions.isNotEmpty;
    if (hasStage3Evolutions) {
      for (var evolution in stage2Evolutions) {
        for (var stage3Evolution in evolution.evolutions) {
          stage3Evolutions.add(stage3Evolution);
        }
      }
    }

    List<Future<Response>> futureResponses = [];

    // 1st pokemon
    var fetchPokemonUrl = '$baseUrl/pokemon/${chain.chain.pokemonName}';
    futureResponses.add(dio.get(fetchPokemonUrl));

    // stage 2 evolutions
    if (hasStage2Evolutions) {
      for (var stage2Evolution in stage2Evolutions) {
        fetchPokemonUrl = '$baseUrl/pokemon/${stage2Evolution.pokemonName}';
        futureResponses.add(dio.get(fetchPokemonUrl));
      }
    }

    // stage 3 evolutions
    if (hasStage3Evolutions) {
      for (var stage3Evolution in stage3Evolutions) {
        fetchPokemonUrl = '$baseUrl/pokemon/${stage3Evolution.pokemonName}';
        futureResponses.add(dio.get(fetchPokemonUrl));
      }
    }

    List<Response> responses = await Future.wait(futureResponses);

    // base pokemon
    final pokemon = Pokemon.fromJson(responses[0].data);
    chain.chain.imageUrl = pokemon.imageUrl;
    chain.chain.pokemonId = pokemon.id;

    // stage 2 evolutions
    for (var i = 0; i < stage2Evolutions.length; ++i) {
      var index = 1 + i;
      final pokemon = Pokemon.fromJson(responses[index].data);
      stage2Evolutions[i].imageUrl = pokemon.imageUrl;
      stage2Evolutions[i].pokemonId = pokemon.id;
    }

    for (var i = 0; i < stage3Evolutions.length; ++i) {
      var index = 1 + stage2Evolutions.length + i;
      final pokemon = Pokemon.fromJson(responses[index].data);
      stage3Evolutions[i].imageUrl = pokemon.imageUrl;
      stage3Evolutions[i].pokemonId = pokemon.id;
    }
  }
}

import 'package:flutter/cupertino.dart';
import 'package:pokedex/models/pokemon_evolution_chain.dart';
import 'package:pokedex/models/pokemon_species.dart';
import 'package:pokedex/models/simple_pokemon_list.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:dio/dio.dart';

const String _baseUrl = 'https://pokeapi.co/api/v2';

Future<SimplePokemonList> fetchPokemonListFromApi(
    {int offset = 0, int limit = 20}) async {
  print('fetchPokemonListFromApi()');
  try {
//    final fetchUrl = '$_baseUrl/pokemon';
//    final fetchUrl = '$_baseUrl/pokemon?offset=438&limit=10'; // mime jr
    final fetchUrl = '$_baseUrl/pokemon?offset=279&limit=10'; // ralts
//    final fetchUrl = '$_baseUrl/pokemon?offset=132&limit=10'; // eevee
//    final fetchUrl = '$_baseUrl/pokemon?offset=264&limit=10'; // wurmple
//    final fetchUrl = '$_baseUrl/pokemon?offset=230&limit=10'; // hitmonlee
    final response = await Dio().get(fetchUrl);
    final pokemonList = SimplePokemonList.fromJson(response.data);

    return pokemonList;
  } catch (e) {
    print(e);
  }
}

Future<List<Pokemon>> fetchPokemonDetailsListFromApi(
    SimplePokemonList pokemonList) async {
  print('fetchDetailsList()');
  try {
    final List<Response> responses =
        await _fetchPokemonDetailsResponses(pokemonList);

    // Build list of fetched Pokemon.
    List<Pokemon> pokemonDetailsList = [];
    for (var response in responses) {
      final pokemon = _buildPokemonFromResponse(response);
      pokemonDetailsList.add(pokemon);
    }

    // Since the calls were made concurrently, sort the Pokemon in ascending
    // order based on their ID.
    pokemonDetailsList
        .sort((pokemonA, pokemonB) => pokemonA.id.compareTo(pokemonB.id));

    return pokemonDetailsList;
  } catch (e) {
    print(e);
  }
}

Future<Pokemon> fetchPokemonDetailsFromApi({String name, int id}) async {
  print('fetchPokemonDetailsFromApi()');
  try {
    // Fetch pokemon details.
    final fetchPokemonUrl = (name != null && name.isNotEmpty)
        ? '$_baseUrl/pokemon/$name'
        : '$_baseUrl/pokemon/$id';
    print('fetchPokemonUrl=$fetchPokemonUrl');

    // Fetch species details.
    final fetchSpeciesUrl = (name != null && name.isNotEmpty)
        ? '$_baseUrl/pokemon-species/$name'
        : '$_baseUrl/pokemon-species/$id';
    print('fetchSpeciesUrl=$fetchSpeciesUrl');

    //
    List<Future<Response>> futureResponses = [];
    futureResponses.addAll([
      Dio().get(fetchPokemonUrl),
      Dio().get(fetchSpeciesUrl),
    ]);
    List<Response> responses = await Future.wait(futureResponses);
    final pokemon = Pokemon.fromJson(responses[0].data);
    final species = PokemonSpecies.fromJson(responses[1].data);
    //

//    final pokemonResponse = await Dio().get(fetchPokemonUrl);
//    var pokemon = Pokemon.fromJson(pokemonResponse.data);
//
//    final speciesResponse = await Dio().get(fetchSpeciesUrl);
//    final species = PokemonSpecies.fromJson(speciesResponse.data);
//    pokemon.species = species;

    print('fetching evolution');
    // Fetch evolution chain details
    final evolutionChainResponse = await Dio().get(species.evolutionChainUrl);
    final evolutionChain = PokemonEvolutionChain.fromJson(evolutionChainResponse.data);
    pokemon.evolutionChain = evolutionChain;
    print('fetched evolution');


    // Fetch images for evolution chain.
    await _fetchImagesForEvolutionChain(pokemon.evolutionChain);
    return pokemon;
  } catch (e) {
    print(e);
  }
}

Future _fetchImagesForEvolutionChain(PokemonEvolutionChain chain) async {
  print('fetching images');
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


  List<Future<Response>> futureStage2Responses = [];
  List<Future<Response>> futureStage3Responses = [];

  var fetchImageUrl;
  if (hasStage2Evolutions) {
    for (var stage2Evolution in stage2Evolutions) {
      fetchImageUrl = '$_baseUrl/pokemon/${stage2Evolution.speciesName}';
      print('to fetch=$fetchImageUrl');
      futureStage2Responses.add(Dio().get(fetchImageUrl));
    }
  }

  if (hasStage3Evolutions) {
    for (var stage3Evolution in stage3Evolutions) {
      fetchImageUrl = '$_baseUrl/pokemon/${stage3Evolution.speciesName}';
      print('to fetch=$fetchImageUrl');
      futureStage3Responses.add(Dio().get(fetchImageUrl));
    }
  }

  List<Response> stage2Responses = await Future.wait(futureStage2Responses);
  List<Response> stage3Responses = await Future.wait(futureStage3Responses);
  for (var i = 0; i < stage2Responses.length; ++i) {
    final pokemon = Pokemon.fromJson(stage2Responses[i].data);
    // TODO: Investigate as the potential source of bug.
    stage2Evolutions[i].imageUrl = pokemon.imageUrl;
  }

  for (var i = 0; i < stage3Responses.length; ++i) {
    final pokemon = Pokemon.fromJson(stage3Responses[i].data);
    // TODO: Investigate as the potential source of bug.
    stage3Evolutions[i].imageUrl = pokemon.imageUrl;
  }

  print('fetched images');
}


Future<PokemonEvolutionChain> fetchPokemonEvolutionChainFromApi(
    String speciesUrl) async {
  print('fetchEvolutionChain()');
  try {
    final speciesResponse = await Dio().get(speciesUrl);
    PokemonSpecies pokemonSpecies =
        PokemonSpecies.fromJson(speciesResponse.data);

    final evolutionResponse = await Dio().get(pokemonSpecies.evolutionChainUrl);
    PokemonEvolutionChain evolutionChain =
        PokemonEvolutionChain.fromJson(evolutionResponse.data);

    return evolutionChain;
  } catch (e) {
    print(e);
  }
}

Future<List<Response>> _fetchPokemonDetailsResponses(
    SimplePokemonList simplePokemonList) async {
  print('_fetchPokemonDetailsResponses');
  // Fetch pokemon details using detailsUrl inside each simplePokemon.
  List<Future<Response>> responses = [];
  for (var i = 0; i < simplePokemonList.simplePokemonList.length; ++i) {
    final fetchUrl = simplePokemonList.simplePokemonList[i].detailsUrl;
    final response = Dio().get(fetchUrl);
    responses.add(response);
  }

  // Combine the results of the concurrent API calls.
  var results = await Future.wait(responses);

  return results;
}

Pokemon _buildPokemonFromResponse(Response response) {
  return Pokemon.fromJson(response.data);
}

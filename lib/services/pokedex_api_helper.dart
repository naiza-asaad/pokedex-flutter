import 'package:pokedex/models/pokemon_evolution_chain.dart';
import 'package:pokedex/models/pokemon_species.dart';
import 'package:pokedex/models/simple_pokemon_list.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:dio/dio.dart';

const String _baseUrl = 'https://pokeapi.co/api/v2';

Future<SimplePokemonList> fetchPokemonListFromApi(
    {int offset = 0, int limit = 20}) async {
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
  try {
    // Fetch pokemon details.
    final fetchPokemonUrl = (name != null && name.isNotEmpty)
        ? '$_baseUrl/pokemon/$name'
        : '$_baseUrl/pokemon/$id';

    // Fetch species details.
    final fetchSpeciesUrl = (name != null && name.isNotEmpty)
        ? '$_baseUrl/pokemon-species/$name'
        : '$_baseUrl/pokemon-species/$id';

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

    // Fetch evolution chain details
    final evolutionChainResponse = await Dio().get(species.evolutionChainUrl);
    final evolutionChain = PokemonEvolutionChain.fromJson(evolutionChainResponse.data);
    pokemon.evolutionChain = evolutionChain;

    return pokemon;
  } catch (e) {
    print(e);
  }
}

Future<PokemonEvolutionChain> fetchPokemonEvolutionChainFromApi(
    String speciesUrl) async {
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

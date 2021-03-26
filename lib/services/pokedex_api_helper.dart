import 'package:pokedex/models/pokemon_evolution_chain.dart';
import 'package:pokedex/models/pokemon_species.dart';
import 'package:pokedex/models/simple_pokemon_list.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:dio/dio.dart';

const String _baseUrl = 'https://pokeapi.co/api/v2';

Future<SimplePokemonList> fetchPokemonListFromApi(
    {int offset = 0, int limit = 20}) async {
  try {
    final fetchUrl = '$_baseUrl/pokemon';
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
    final fetchUrl = (name != null && name.isNotEmpty)
        ? '$_baseUrl/pokemon/$name'
        : '$_baseUrl/pokemon/$id';

    final pokemonResponse = await Dio().get(fetchUrl);
    var pokemon = Pokemon.fromJson(pokemonResponse.data);

    // Fetch species details.
    final speciesResponse = await Dio().get(pokemon.speciesDetailsUrl);
    final species = PokemonSpecies.fromJson(speciesResponse.data);
    pokemon.species = species;

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

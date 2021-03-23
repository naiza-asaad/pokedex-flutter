
import 'package:pokedex/models/simple_pokemon_list.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/services/pokedex_api_helper.dart';

class PokedexApiService {
  PokedexApiHelper _pokedexApiHelper;

  PokedexApiService() {
    _pokedexApiHelper = PokedexApiHelper();
  }

  Future<SimplePokemonList> fetchPokemonList({int offset = 0, int limit = 20}) async {
    SimplePokemonList pokemonList = await _pokedexApiHelper.fetchPokemonList(limit: limit, offset: offset);
    return pokemonList;
  }

  Future<List<Pokemon>> fetchPokemonDetailsList(SimplePokemonList pokemonList) async {
    List<Pokemon> pokemonDetailsList = await _pokedexApiHelper.fetchPokemonDetailsList(pokemonList);
    return pokemonDetailsList;
  }

}
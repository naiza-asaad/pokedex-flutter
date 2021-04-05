import 'package:pokedex/models/pokemon/pokemon.dart';
import 'package:pokedex/models/simple_pokemon/simple_pokemon.dart';

/// SimplePokemonList only contains the name and detailsUrl of each Pokemon.
/// We fetch the details (types, image, etc.) after fetching simplePokemonList.
class SimplePokemonList {
  int count;
  String next;
  String previous;
  List<SimplePokemon> simplePokemonList;
  List<Pokemon> pokemonList;

  SimplePokemonList({
    this.count,
    this.next,
    this.previous,
    this.simplePokemonList,
  }) : pokemonList = [];

  factory SimplePokemonList.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['results'] as List;
    List<SimplePokemon> simplePokemonList =
        list.map((e) => SimplePokemon.fromJson(e)).toList();

    return SimplePokemonList(
      count: parsedJson['count'],
      next: parsedJson['next'],
      previous: parsedJson['previous'],
      simplePokemonList: simplePokemonList,
    );
  }

  @override
  String toString() {
    return 'count=$count, next=$next, previous=$previous, list=$simplePokemonList';
  }
}

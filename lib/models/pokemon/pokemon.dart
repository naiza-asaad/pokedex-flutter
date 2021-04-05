import 'package:pokedex/models/pokemon/pokemon_ability.dart';
import 'package:pokedex/models/pokemon/pokemon_base_stats.dart';
import 'package:pokedex/models/pokemon/pokemon_move.dart';
import 'package:pokedex/models/pokemon/pokemon_type.dart';
import 'package:pokedex/models/pokemon_evolution/pokemon_evolution_chain.dart';
import 'package:pokedex/models/pokemon_species/pokemon_species.dart';
import 'package:pokedex/utilities/string_extension.dart';

class Pokemon {
  int id;
  String name;
  String imageUrl;
  List<PokemonType> typeList;
  List<PokemonAbility> abilityList;
  int heightInDecimeters;
  int weightInDecimeters;
  int baseExperience;
  PokemonBaseStats baseStats;
  String speciesDetailsUrl;
  List<PokemonMove> moveList;

  PokemonSpecies species;
  PokemonEvolutionChain evolutionChain;

  Pokemon({
    this.id,
    this.name,
    this.imageUrl,
    this.typeList,
    this.abilityList,
    this.heightInDecimeters,
    this.weightInDecimeters,
    this.baseExperience,
    this.baseStats,
    this.speciesDetailsUrl,
    this.moveList,
  });

  factory Pokemon.fromJson(Map<String, dynamic> parsedJson) {
    var tempTypeList = parsedJson['types'] as List;
    List<PokemonType> typeList =
        tempTypeList.map((e) => PokemonType.fromJson(e)).toList();

    var tempAbilityList = parsedJson['abilities'] as List;
    List<PokemonAbility> abilityList =
        tempAbilityList.map((e) => PokemonAbility.fromJson(e)).toList();

    var tempMoveList = parsedJson['moves'] as List;
    List<PokemonMove> moveList =
        tempMoveList.map((e) => PokemonMove.fromJson(e)).toList();

    return Pokemon(
      id: parsedJson['id'],
      name: (parsedJson['name'] as String).inCaps,
      imageUrl: parsedJson['sprites']['other']['official-artwork']
          ['front_default'],
      typeList: typeList,
      abilityList: abilityList,
      heightInDecimeters: parsedJson['height'],
      weightInDecimeters: parsedJson['weight'],
      baseExperience: parsedJson['base_experience'],
      baseStats: PokemonBaseStats.fromJson(parsedJson['stats']),
      speciesDetailsUrl: parsedJson['species']['url'],
      moveList: moveList,
    );
  }

  @override
  String toString() {
    return 'name=$name, imageUrl=$imageUrl, typeList=$typeList';
  }
}

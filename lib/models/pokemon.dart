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
  });

  factory Pokemon.fromJson(Map<String, dynamic> parsedJson) {
    var tempTypeList = parsedJson['types'] as List;
    List<PokemonType> typeList =
        tempTypeList.map((e) => PokemonType.fromJson(e)).toList();

    var tempAbilityList = parsedJson['abilities'] as List;
    List<PokemonAbility> abilityList =
        tempAbilityList.map((e) => PokemonAbility.fromJson(e)).toList();

    return Pokemon(
      id: parsedJson['id'],
      name: (parsedJson['name'] as String).inCaps,
      imageUrl: parsedJson['sprites']['other']['official-artwork']
          ['front_default'],
//      imageUrl: parsedJson['sprites']['front_default'],
      typeList: typeList,
      abilityList: abilityList,
      heightInDecimeters: parsedJson['height'],
      weightInDecimeters: parsedJson['weight'],
      baseExperience: parsedJson['base_experience'],
      baseStats: PokemonBaseStats.fromJson(parsedJson['stats']),
    );
  }

  @override
  String toString() {
    return 'name=$name, imageUrl=$imageUrl, typeList=$typeList';
  }
}

class PokemonBaseStats {
  int hp;
  int attack;
  int defense;
  int specialAttack;
  int specialDefense;
  int speed;

  PokemonBaseStats({
    this.hp,
    this.attack,
    this.defense,
    this.specialAttack,
    this.specialDefense,
    this.speed,
  });

  factory PokemonBaseStats.fromJson(List<dynamic> parsedList) {
    List<PokemonBaseStat> baseStatList = parsedList.map((e) => PokemonBaseStat.fromJson(e)).toList();
    return PokemonBaseStats(
      hp: baseStatList[0].baseStat,
      attack: baseStatList[1].baseStat,
      defense: baseStatList[2].baseStat,
      specialAttack: baseStatList[3].baseStat,
      specialDefense: baseStatList[4].baseStat,
      speed: baseStatList[5].baseStat,
    );
  }

  @override
  String toString() {
    return 'hp=$hp, attack=$attack, defense=$defense, specialAttack=$specialAttack, specialDefense=$specialDefense, speed=$speed';
  }
}

class PokemonBaseStat{
  int baseStat;
  String name;
  String detailsUrl;

  PokemonBaseStat({
    this.baseStat,
    this.name,
    this.detailsUrl,
  });

  factory PokemonBaseStat.fromJson(Map<String, dynamic> parsedJson) {
    return PokemonBaseStat(
      baseStat: parsedJson['base_stat'],
      name: parsedJson['stat']['name'],
      detailsUrl: parsedJson['stat']['url'],
    );
  }

  @override
  String toString() {
    return 'name=$name, stat=$baseStat, url=$detailsUrl';
  }
}

class PokemonAbility {
  String name;
  String detailsUrl;

  PokemonAbility({
    this.name,
    this.detailsUrl,
  });

  factory PokemonAbility.fromJson(Map<String, dynamic> parsedJson) {
    return PokemonAbility(
      name: (parsedJson['ability']['name'] as String).inCaps,
      detailsUrl: parsedJson['ability']['url'],
    );
  }

  @override
  String toString() {
    return 'ability name=$name, url=$detailsUrl';
  }
}

class PokemonType {
  int slot;
  Type type;

  PokemonType({
    this.slot,
    this.type,
  });

  factory PokemonType.fromJson(Map<String, dynamic> parsedJson) {
    return PokemonType(
      slot: parsedJson['slot'],
      type: Type.fromJson(parsedJson['type']),
    );
  }

  @override
  String toString() {
    return 'type=$type';
  }
}

class Type {
  String name;
  String url;

  Type({
    this.name,
    this.url,
  });

  factory Type.fromJson(Map<String, dynamic> parsedJson) {
    return Type(
      name: parsedJson['name'],
      url: parsedJson['url'],
    );
  }

  @override
  String toString() {
    return 'type name=$name\n';
  }
}

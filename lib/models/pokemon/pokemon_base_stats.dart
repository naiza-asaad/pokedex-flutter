import 'package:pokedex/models/pokemon/pokemon_base_stat.dart';

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
    List<PokemonBaseStat> baseStatList =
        parsedList.map((e) => PokemonBaseStat.fromJson(e)).toList();
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

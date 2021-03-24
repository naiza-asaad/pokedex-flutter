import 'package:pokedex/utilities/string_extension.dart';

class Pokemon {
  int id;
  String name;
  String imageUrl;
  List<PokemonType> typeList;

  Pokemon({
    this.id,
    this.name,
    this.imageUrl,
    this.typeList,
  });

  factory Pokemon.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['types'] as List;
    List<PokemonType> typeList = list.map((e) => PokemonType.fromJson(e)).toList();

    return Pokemon(
      id: parsedJson['id'],
      name: (parsedJson['name'] as String).inCaps,
//      imageUrl: parsedJson['sprites']['other']['official-artwork']['front_default'],
      imageUrl: parsedJson['sprites']['front_default'],
      typeList: typeList,
    );
  }

  @override
  String toString() {
    return 'name=$name, imageUrl=$imageUrl, typeList=$typeList';
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

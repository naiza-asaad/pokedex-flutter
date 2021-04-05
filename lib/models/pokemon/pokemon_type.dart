import 'package:pokedex/models/pokemon/type.dart';

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

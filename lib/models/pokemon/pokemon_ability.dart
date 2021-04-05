import 'package:pokedex/utilities/string_extension.dart';

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

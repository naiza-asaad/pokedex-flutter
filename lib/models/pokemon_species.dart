class PokemonSpecies {
  String evolutionChainUrl;
  String flavorTextEntry1;

  PokemonSpecies({
    this.evolutionChainUrl,
    this.flavorTextEntry1,
  });

  factory PokemonSpecies.fromJson(Map<String, dynamic> parsedJson) {
    print('hello????');
    return PokemonSpecies(
      evolutionChainUrl: parsedJson['evolution_chain']['url'],
      flavorTextEntry1: parsedJson['flavor_text_entries'][0]['flavor_text'],
    );
  }

//  @override
//  String toString() {
////    return 'evolutionChainUrl=$evolutionChainUrl';
//    return 'evolutionChainUrl=$evolutionChainUrl, flavorTextEntry1=$flavorTextEntry1';
//  }
}
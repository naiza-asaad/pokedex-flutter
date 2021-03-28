class PokemonSpecies {
  String evolutionChainUrl;
  String flavorTextEntry1;

  PokemonSpecies({
    this.evolutionChainUrl,
    this.flavorTextEntry1,
  });

  factory PokemonSpecies.fromJson(Map<String, dynamic> parsedJson) {
    var tempFlavorTextList = parsedJson['flavor_text_entries'] as List;
    // Always fetches the first English flavor text entry.
    // The first element of the list is usually, BUT NOT ALWAYS, the first English entry.
    // So, check for the actual language first.
    final firstEnglishFlavorTextEntryIndex = tempFlavorTextList
        .indexWhere((element) => element['language']['name'] as String == 'en');

    // Removes flavor text entries' escape sequences ('\n' and '\u000c') in between sentences.
    // These are returned by the API to probably copy the original look of the actual Pokedex inside the games.
    final flavorText = (parsedJson['flavor_text_entries']
            [firstEnglishFlavorTextEntryIndex]['flavor_text'] as String)
        .replaceAll('\n', ' ')
        .replaceAll('\u000c', ' ');

    return PokemonSpecies(
      evolutionChainUrl: parsedJson['evolution_chain']['url'],
      flavorTextEntry1: flavorText,
    );
  }

//  @override
//  String toString() {
////    return 'evolutionChainUrl=$evolutionChainUrl';
//    return 'evolutionChainUrl=$evolutionChainUrl, flavorTextEntry1=$flavorTextEntry1';
//  }
}

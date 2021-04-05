import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon/pokemon.dart';
import 'package:pokedex/pages/pokemon_list_page/widgets/pokemon_list_card.dart';
import 'package:pokedex/utilities/global_constants.dart';

class PokemonSearchResultsGrid extends StatelessWidget {
  final List<Pokemon> searchResultList;

  const PokemonSearchResultsGrid({
    this.searchResultList,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: searchResultList.length,
      gridDelegate: kPokemonGridDelegate,
      itemBuilder: (context, index) {
        return PokemonListCard(searchResultList[index]);
      },
    );
  }
}

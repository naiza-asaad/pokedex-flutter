import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon/pokemon.dart';
import 'package:pokedex/pages/pokemon_list_page/pokemon_list_card/pokemon_list_card.dart';
import 'package:pokedex/pages/pokemon_page/pokemon_page.dart';
import 'package:pokedex/utilities/global_constants.dart';
import 'package:pokedex/utilities/pokemon_color_picker.dart';

class PokemonSearchResultsGrid extends StatelessWidget {
  final List<Pokemon> searchResultList;

  const PokemonSearchResultsGrid({
    @required this.searchResultList,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: searchResultList.length,
      gridDelegate: kPokemonGridDelegate,
      itemBuilder: (context, index) {
        Pokemon pokemon = searchResultList[index];
        return PokemonListCard(
          pokemon: pokemon,
          onTap: () {
            Navigator.pushNamed(
              context,
              PokemonPage.route,
              arguments: PokemonPageArguments(
                pokemon: pokemon,
                mainTypeColor:
                    PokemonColorPicker.getColor(pokemon.typeList[0].type.name),
              ),
            );
          },
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon/pokemon.dart';
import 'package:pokedex/pages/pokemon_list_page/pokemon_list_card/widgets/pokemon_image.dart';
import 'package:pokedex/pages/pokemon_list_page/pokemon_list_card/widgets/pokemon_name.dart';
import 'package:pokedex/pages/pokemon_list_page/pokemon_list_card/widgets/pokemon_type_list.dart';
import 'package:pokedex/pages/pokemon_page/pokemon_page.dart';
import 'package:pokedex/utilities/global_constants.dart';
import 'package:pokedex/utilities/pokemon_color_picker.dart';

class PokemonListCard extends StatelessWidget {
  final Pokemon pokemon;

  PokemonListCard(this.pokemon);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // TODO: Feedback
        // In most cases, callback should be passed in the constructor.
        // Parent widgets should decide what their children should do for callbacks.
        // Because if not, it introduces code coupling.
        // For instance, if this widgets is used in a different page,
        // and onTap of this item it will have a different behavior than navigator to PokemonPage
        return Navigator.pushNamed(
          context,
          PokemonPage.route,
          arguments: PokemonPageArguments(
            pokemon,
            PokemonColorPicker.getColor(pokemon.typeList[0].type.name),
          ),
        );
      },
      child: Card(
        color: PokemonColorPicker.getColor(pokemon.typeList[0].type.name),
        child: Stack(
          children: [
            Padding(
              padding: kCardPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PokemonName(name: pokemon.name),
                  PokemonTypeList(typeList: pokemon.typeList),
                ],
              ),
            ),
            Positioned(
              bottom: kPokemonImagePositionedBottom,
              right: kPokemonImagePositionedRight,
              child: PokemonImage(
                imageUrl: pokemon.imageUrl,
                pokemonId: pokemon.id,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

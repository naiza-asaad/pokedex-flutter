import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon/pokemon.dart';
import 'package:pokedex/pages/pokemon_page/pokemon_page_header/widgets/pokemon_id.dart';
import 'package:pokedex/pages/pokemon_page/pokemon_page_header/widgets/pokemon_image.dart';
import 'package:pokedex/pages/pokemon_page/pokemon_page_header/widgets/pokemon_type_list.dart';
import 'package:pokedex/utilities/global_constants.dart';

class PokemonPageHeader extends StatelessWidget {
  const PokemonPageHeader({
    Key key,
    @required this.pokemon,
  }) : super(key: key);

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: kPokemonPageHeaderPadding,
        child: Row(
          children: [
            Expanded(
              flex: kPokemonPageHeaderRow1Flex,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pokemon.name,
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  if (MediaQuery.of(context).orientation ==
                      Orientation.portrait)
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: kPokemonPageHeaderIdPadding,
                        child: PokemonId(id: pokemon.id),
                      ),
                    )
                  else
                    PokemonId(id: pokemon.id),
                  PokemonTypeList(typeList: pokemon.typeList),
                ],
              ),
            ),
            if (MediaQuery.of(context).orientation == Orientation.landscape)
              Expanded(
                child: PokemonImage(pokemon: pokemon),
              ),
          ],
        ),
      ),
    );
  }
}

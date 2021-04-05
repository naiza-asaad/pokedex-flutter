import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon/pokemon_type.dart';
import 'package:pokedex/pages/pokemon_page/pokemon_page_header/widgets/pokemon_type_name.dart';
import 'package:pokedex/utilities/global_constants.dart';

class PokemonTypeList extends StatelessWidget {
  const PokemonTypeList({
    Key key,
    @required List<PokemonType> typeList,
  })  : typeList = typeList,
        super(key: key);

  final List<PokemonType> typeList;

  @override
  Widget build(BuildContext context) {
    if (typeList.length > 1) {
      // Pokemon has 2 types
      return Padding(
        padding: kPokemonPageHeaderTypeListTopPadding,
        child: Row(
          children: [
            PokemonTypeName(
              name: typeList[0].type.name,
              mainTypeName: typeList[0].type.name,
            ),
            PokemonTypeName(
              name: typeList[1].type.name,
              mainTypeName: typeList[0].type.name,
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: kPokemonPageHeaderTypeListTopPadding,
        child: PokemonTypeName(
          name: typeList[0].type.name,
          mainTypeName: typeList[0].type.name,
        ),
      );
    }
  }
}

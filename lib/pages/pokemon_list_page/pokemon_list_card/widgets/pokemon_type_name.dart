import 'package:flutter/material.dart';
import 'package:pokedex/utilities/color_utilities.dart';
import 'package:pokedex/utilities/global_constants.dart';
import 'package:pokedex/utilities/pokemon_color_picker.dart';
import 'package:pokedex/utilities/string_extension.dart';

class PokemonTypeName extends StatelessWidget {
  const PokemonTypeName({
    Key key,
    @required String name,
    @required String mainTypeName,
  })  : name = name,
        mainTypeName = mainTypeName,
        super(key: key);

  final String name;
  final String mainTypeName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: kPokemonTypePadding,
      margin: kPokemonTypeMargin,
      decoration: BoxDecoration(
        color: lighten(PokemonColorPicker.getColor(mainTypeName)),
        border: Border.all(color: kPokemonTypeBorderColor),
        borderRadius: kPokemonTypeBorderRadius,
      ),
      child: Text(
        name.inCaps,
        style: Theme.of(context).textTheme.headline4,
      ),
    );
  }
}

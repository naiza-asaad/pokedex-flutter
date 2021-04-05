import 'package:flutter/material.dart';
import 'package:pokedex/utilities/global_constants.dart';

class PokemonName extends StatelessWidget {
  const PokemonName({
    Key key,
    @required String name,
  })  : name = name,
        super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: kPokemonNamePadding,
      child: Text(
        name,
        style: Theme.of(context).textTheme.headline4,
      ),
    );
  }
}

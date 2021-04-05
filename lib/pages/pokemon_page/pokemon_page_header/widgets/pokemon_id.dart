import 'package:flutter/material.dart';
import 'package:pokedex/utilities/string_extension.dart';

class PokemonId extends StatelessWidget {
  const PokemonId({
    Key key,
    @required this.id,
  }) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    return Text(
      '#${formatPokemonId(id)}',
      style: Theme.of(context).textTheme.headline3,
    );
  }
}

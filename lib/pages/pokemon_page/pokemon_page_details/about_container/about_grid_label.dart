import 'package:flutter/material.dart';
import 'package:pokedex/utilities/global_constants.dart';

class AboutGridLabel extends StatelessWidget {
  const AboutGridLabel(
    this.label, {
    Key key,
    this.pokemonColor,
  }) : super(key: key);

  final String label;
  final Color pokemonColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: kAboutGridTextPadding,
      child: Text(
        label,
        textAlign: TextAlign.right,
        style: Theme.of(context).textTheme.bodyText2.copyWith(
              fontSize: 18.0,
            ),
      ),
    );
  }
}

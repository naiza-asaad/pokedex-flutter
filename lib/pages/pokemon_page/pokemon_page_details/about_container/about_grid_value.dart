import 'package:flutter/material.dart';
import 'package:pokedex/utilities/global_constants.dart';

class AboutGridValue extends StatelessWidget {
  const AboutGridValue(
    this.value, {
    Key key,
  }) : super(key: key);

  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: kAboutGridTextPadding,
      child: Text(
        value,
        style: Theme.of(context).textTheme.bodyText2.copyWith(),
      ),
    );
  }
}

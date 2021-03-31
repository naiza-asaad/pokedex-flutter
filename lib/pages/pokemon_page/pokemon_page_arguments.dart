import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon.dart';

class PokemonPageArguments {
  final Pokemon pokemon;
  final Color mainTypeColor;

  PokemonPageArguments(
    this.pokemon,
    this.mainTypeColor,
  );
}

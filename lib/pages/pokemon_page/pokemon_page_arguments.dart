import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon.dart';

// COMMENT RAEL: put this inside pokemon_page.dart
class PokemonPageArguments {
  final Pokemon pokemon;
  final Color mainTypeColor;

  PokemonPageArguments(
    this.pokemon,
    this.mainTypeColor,
  );
}

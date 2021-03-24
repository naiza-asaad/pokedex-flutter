import 'package:flutter/material.dart';

class PokemonColorPicker {
  static Color getColor(String type) {
    switch (type) {
      case 'normal':
        return Color(0xffA8A77A);
      case 'fire':
        return Color(0xffF5AC78);
      case 'water':
        return Color(0xff9DB7F5);
      case 'electric':
        return Color(0xffF7D02C);
      case 'grass':
        return Color(0xffA7DB8D);
      case 'ice':
        return Color(0xff96D9D6);
      case 'fighting':
        return Color(0xffC22E28);
      case 'poison':
        return Color(0xffA33EA1);
      case 'ground':
        return Color(0xffE2BF65);
      case 'flying':
        return Color(0xffA98FF3);
      case 'psychic':
        return Color(0xffF95587);
      case 'bug':
        return Color(0xffA6B91A);
      case 'rock':
        return Color(0xffB6A136);
      case 'ghost':
        return Color(0xff735797);
      case 'dragon':
        return Color(0xff6F35FC);
      case 'dark':
        return Color(0xff705746);
      case 'steel':
        return Color(0xffB7B7CE);
      case 'fairy':
        return Color(0xffD685AD);
    }
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon/pokemon.dart';
import 'package:pokedex/utilities/global_constants.dart';

class PokemonImage extends StatelessWidget {
  const PokemonImage({
    Key key,
    @required this.pokemon,
  }) : super(key: key);

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'pokemonImage${pokemon.imageUrl}',
      child: Container(
        width: kPokemonPageHeaderImageWidth,
        height: kPokemonPageHeaderImageHeight,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: CachedNetworkImageProvider(pokemon.imageUrl),
          ),
        ),
      ),
    );
  }
}

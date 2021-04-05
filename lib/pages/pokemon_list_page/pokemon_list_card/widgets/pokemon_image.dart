import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/utilities/global_constants.dart';

class PokemonImage extends StatelessWidget {
  const PokemonImage({
    Key key,
    @required String imageUrl,
    @required int pokemonId,
  })  : imageUrl = imageUrl,
        pokemonId = pokemonId,
        super(key: key);

  final String imageUrl;
  final int pokemonId;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'pokemonImage$pokemonId',
      child: Container(
        width: kPokemonListCardImageWidth,
        height: kPokemonListCardImageHeight,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: CachedNetworkImageProvider(imageUrl),
          ),
        ),
      ),
    );
  }
}

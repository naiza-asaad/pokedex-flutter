import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/pages/pokemon_page/pokemon_page.dart';
import 'package:pokedex/pages/pokemon_page/pokemon_page_arguments.dart';
import 'package:pokedex/utilities/color_utilities.dart';
import 'package:pokedex/utilities/global_constants.dart';
import 'package:pokedex/utilities/pokemon_color_picker.dart';
import 'package:pokedex/utilities/string_extension.dart';

class PokemonListCard extends StatelessWidget {
  final Pokemon pokemon;

  PokemonListCard(this.pokemon);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(
        context,
        PokemonPage.route,
        arguments: PokemonPageArguments(
          pokemon,
          PokemonColorPicker.getColor(pokemon.typeList[0].type.name),
        ),
      ),
      child: Card(
        color: PokemonColorPicker.getColor(pokemon.typeList[0].type.name),
        child: Stack(
          children: [
            Padding(
              padding: kCardPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PokemonName(name: pokemon.name),
                  PokemonTypeList(typeList: pokemon.typeList),
                ],
              ),
            ),
            Positioned(
              bottom: kPokemonImagePositionedBottom,
              right: kPokemonImagePositionedRight,
              child: PokemonImage(
                imageUrl: pokemon.imageUrl,
                pokemonId: pokemon.id,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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

class PokemonTypeList extends StatelessWidget {
  const PokemonTypeList({
    Key key,
    @required List<PokemonType> typeList,
  })  : typeList = typeList,
        super(key: key);

  final List<PokemonType> typeList;

  @override
  Widget build(BuildContext context) {
    if (typeList.length > 1) {
      // Pokemon has 2 types
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PokemonTypeName(
            name: typeList[0].type.name,
            mainTypeName: typeList[0].type.name,
          ),
          PokemonTypeName(
            name: typeList[1].type.name,
            mainTypeName: typeList[0].type.name,
          ),
        ],
      );
    } else {
      return PokemonTypeName(
        name: typeList[0].type.name,
        mainTypeName: typeList[0].type.name,
      );
    }
  }
}

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

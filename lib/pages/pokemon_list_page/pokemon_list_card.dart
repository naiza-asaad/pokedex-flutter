import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/pages/pokemon_page/pokemon_page.dart';
import 'package:pokedex/pages/pokemon_page/pokemon_page_arguments.dart';
import 'package:pokedex/utilities/color_utilities.dart';
import 'package:pokedex/utilities/pokemon_color_picker.dart';
import 'package:pokedex/utilities/string_extension.dart';

class PokemonListCard extends StatelessWidget {
  final Pokemon _pokemon;

  PokemonListCard(this._pokemon);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(
        context,
        PokemonPage.route,
        arguments: PokemonPageArguments(
          _pokemon,
          PokemonColorPicker.getColor(_pokemon.typeList[0].type.name),
        ),
      ),
      child: Card(
        color: PokemonColorPicker.getColor(_pokemon.typeList[0].type.name),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PokemonName(name: _pokemon.name),
                  PokemonTypeList(typeList: _pokemon.typeList),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: PokemonImage(
                imageUrl: _pokemon.imageUrl,
                pokemonId: _pokemon.id,
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
  })  : _name = name,
        super(key: key);

  final String _name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        _name,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
        ),
      ),
    );
  }
}

class PokemonTypeList extends StatelessWidget {
  const PokemonTypeList({
    Key key,
    @required List<PokemonType> typeList,
  })  : _typeList = typeList,
        super(key: key);

  final List<PokemonType> _typeList;

  @override
  Widget build(BuildContext context) {
    if (_typeList.length > 1) {
      // Pokemon has 2 types
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PokemonTypeName(
            name: _typeList[0].type.name,
            mainTypeName: _typeList[0].type.name,
          ),
          PokemonTypeName(
            name: _typeList[1].type.name,
            mainTypeName: _typeList[0].type.name,
          ),
        ],
      );
    } else {
      return PokemonTypeName(
        name: _typeList[0].type.name,
        mainTypeName: _typeList[0].type.name,
      );
    }
  }
}

class PokemonTypeName extends StatelessWidget {
  const PokemonTypeName({
    Key key,
    @required String name,
    @required String mainTypeName,
  })  : _name = name,
        _mainTypeName = mainTypeName,
        super(key: key);

  final String _name;
  final String _mainTypeName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 4.0,
        horizontal: 12.0,
      ),
      margin: EdgeInsets.only(bottom: 4.0),
      decoration: BoxDecoration(
        color: lighten(PokemonColorPicker.getColor(_mainTypeName)),
        border: Border.all(
          color: Colors.transparent,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Text(
        _name.inCaps,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14.0,
        ),
      ),
    );
  }
}

class PokemonImage extends StatelessWidget {
  const PokemonImage({
    Key key,
    @required String imageUrl,
    @required int pokemonId,
  })  : _imageUrl = imageUrl,
        _pokemonId = pokemonId,
        super(key: key);

  final String _imageUrl;
  final int _pokemonId;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'pokemonImageHero$_pokemonId',
      child: CachedNetworkImage(
        imageUrl: _imageUrl,
        progressIndicatorBuilder: (context, url, downloadProgress) => Padding(
          padding: const EdgeInsets.only(
            bottom: 16.0,
            right: 16.0,
          ),
          child: CircularProgressIndicator(value: downloadProgress.progress),
        ),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
    );
//    return Image.network(_imageUrl);
  }
}

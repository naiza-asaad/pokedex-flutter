import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon/pokemon.dart';
import 'package:pokedex/pages/pokemon_page/pokemon_page_details/pokemon_page_details.dart';
import 'package:pokedex/pages/pokemon_page/pokemon_page_header/pokemon_page_header.dart';
import 'package:pokedex/pages/pokemon_page/pokemon_page_header/widgets/pokemon_image.dart';
import 'package:pokedex/services/pokemon_service.dart';
import 'package:pokedex/utilities/themes.dart';

class PokemonPage extends StatefulWidget {
  static const String route = '/pokemon';

  final Pokemon pokemon;
  final Color pokemonColor;

  const PokemonPage({
    this.pokemon,
    this.pokemonColor,
  });

  @override
  _PokemonPageState createState() => _PokemonPageState();
}

class _PokemonPageState extends State<PokemonPage> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      primaryColor: widget.pokemonColor,
      pokemon: widget.pokemon,
    );
  }
}

class CustomScaffold extends StatefulWidget {
  final Color primaryColor;
  final Pokemon pokemon;

  CustomScaffold({
    this.primaryColor,
    this.pokemon,
  });

  @override
  _CustomScaffoldState createState() => _CustomScaffoldState();
}

class _CustomScaffoldState extends State<CustomScaffold> {
  Future<Pokemon> futurePokemon;

  @override
  void initState() {
    super.initState();

    futurePokemon =
        PokemonService.fetchPokemonDetails(name: widget.pokemon.name);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      child: Scaffold(
        appBar: AppBar(),
        body: Stack(
          children: [
            Column(
              children: [
                PokemonPageHeader(
                  pokemon: widget.pokemon,
                ),
                PokemonPageDetails(
                  futurePokemon: futurePokemon,
                  pokemonColor: widget.primaryColor,
                ),
              ],
            ),
            if (MediaQuery.of(context).orientation == Orientation.portrait)
              Align(
                alignment: Alignment.lerp(
                  Alignment.topCenter,
                  Alignment.center,
                  0.25,
                ),
                child: PokemonImage(pokemon: widget.pokemon),
              ),
          ],
        ),
      ),
      data: PokedexTheme.themeRegular.copyWith(
        scaffoldBackgroundColor: widget.primaryColor,
        primaryColor: widget.primaryColor,
      ),
    );
  }
}

class PokemonPageArguments {
  final Pokemon pokemon;
  final Color mainTypeColor;

  PokemonPageArguments(
    this.pokemon,
    this.mainTypeColor,
  );
}

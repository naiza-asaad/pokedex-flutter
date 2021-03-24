import 'package:flutter/material.dart';
import 'package:pokedex/pages/pokemon_list_page.dart';
import 'package:pokedex/utilities/app_router.dart';
import 'package:pokedex/utilities/themes.dart';

void main() {
  runApp(PokedexApp());
}

class PokedexApp extends StatefulWidget {
  @override
  _PokedexAppState createState() => _PokedexAppState();
}

class _PokedexAppState extends State<PokedexApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokedex',
      theme: PokedexTheme.themeRegular,
      debugShowCheckedModeBanner: false,
      initialRoute: PokemonListPage.route,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}



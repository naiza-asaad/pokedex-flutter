import 'package:flutter/material.dart';
import 'package:pokedex/pages/pokemon_list_page/pokemon_list_page.dart';
import 'package:pokedex/pages/pokemon_page/pokemon_page.dart';
import 'package:pokedex/pages/pokemon_page/pokemon_page_arguments.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case PokemonListPage.route:
        return MaterialPageRoute(builder: (_) => PokemonListPage());

      case PokemonPage.route:
        final PokemonPageArguments args = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => PokemonPage(
            pokemon: args.pokemon,
            primaryThemeColor: args.mainTypeColor,
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Error: No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}

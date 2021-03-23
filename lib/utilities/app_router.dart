import 'package:flutter/material.dart';
import 'package:pokedex/pages/pokemon_list_page.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case PokemonListPage.route:
        return MaterialPageRoute(builder: (_) => PokemonListPage());
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

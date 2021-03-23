import 'package:flutter/material.dart';
import 'package:pokedex/services/pokedex_api_service.dart';

class PokemonListPage extends StatefulWidget {
  static const String route = '/';

  @override
  _PokemonListPageState createState() => _PokemonListPageState();
}

class _PokemonListPageState extends State<PokemonListPage> {
  
  PokedexApiService _pokedexApiService = PokedexApiService();
  
  @override
  void initState() {
    super.initState();
    fetchPokemonList();
  }

  void fetchPokemonList() async {
    // simplePokemonList only contains the name and detailsUrl of each Pokemon.
    // We fetch the details (types, image, etc.) after fetching simplePokemonList.
    final simplePokemonList = await _pokedexApiService.fetchPokemonList();
    print(simplePokemonList);
    await _pokedexApiService.fetchPokemonDetailsList(simplePokemonList);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Column(
        children: [
            Text('Pokedex'),
        ],
      ),
    );
  }

}

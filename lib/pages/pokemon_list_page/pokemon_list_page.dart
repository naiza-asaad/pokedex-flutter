import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/pages/pokemon_list_page/pokemon_list_card.dart';
import 'package:pokedex/services/pokedex_api_service.dart';

class PokemonListPage extends StatefulWidget {
  static const String route = '/';

  @override
  _PokemonListPageState createState() => _PokemonListPageState();
}

class _PokemonListPageState extends State<PokemonListPage> {
  List<Pokemon> _pokemonList;
  bool isLoading = true;

  final _filter = TextEditingController();
  String _searchText = "";
  Widget _appBarTitle = Text(
    'Pokedex',
    style: TextStyle(
      color: Colors.black,
    ),
  );
  Widget _appBarSearch;
  Widget _appBarWidget;
  Icon _searchIcon = Icon(Icons.search);
  Icon _closeIcon = Icon(Icons.close);
  Icon _appBarActionIcon;

  void _onPressSearch() {
    setState(() {
      if (this._appBarActionIcon.icon == Icons.search) {
        this._appBarActionIcon = _closeIcon;
        this._appBarWidget = _appBarSearch;
      } else {
        this._appBarActionIcon = _searchIcon;
        this._appBarWidget = _appBarTitle;
        _filter.clear();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchPokemonList();

    _appBarWidget = _appBarTitle;
    _appBarSearch = TextField(
      controller: _filter,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search),
        hintText: 'Pikachu',
      ),
    );

    _appBarActionIcon = _searchIcon;
  }

  void fetchPokemonList() async {
    // simplePokemonList only contains the name and detailsUrl of each Pokemon.
    // We fetch the details (types, image, etc.) after fetching simplePokemonList.
    final simplePokemonList = await fetchPokemonListService();
    _pokemonList =
        await fetchPokemonDetailsListService(simplePokemonList);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _appBarWidget,
        actions: [
          IconButton(
            icon: _appBarActionIcon,
            onPressed: _onPressSearch,
          ),
        ],
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 12.0,
          right: 12.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isLoading)
              Center(child: CircularProgressIndicator())
            else
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 3 / 2,
                  ),
                  itemCount: _pokemonList.length,
                  itemBuilder: (context, index) {
                    Pokemon pokemon = _pokemonList[index];
                    return PokemonListCard(pokemon);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}


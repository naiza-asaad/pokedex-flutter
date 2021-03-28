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
  List<Pokemon> _searchResultList;
  bool _isLoading = true;
  bool _hasSearched = false;

  final _filter = TextEditingController();
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

  void _onPressSearchIcon() {
    setState(() {
      if (this._appBarActionIcon.icon == Icons.search) {
        this._appBarActionIcon = _closeIcon;
        this._appBarWidget = _appBarSearch;
      } else {
        this._appBarActionIcon = _searchIcon;
        this._appBarWidget = _appBarTitle;
        _filter.clear();
        _hasSearched = false;
        _searchResultList.clear();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchInitialPokemonList();

    _appBarWidget = _appBarTitle;
    _appBarSearch = TextField(
      controller: _filter,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search),
        hintText: 'Search Pokemon',
      ),
      onSubmitted: _performSearch,
    );

    _appBarActionIcon = _searchIcon;
  }

  /// Fetches initial list and search Pokemon list.
  /// If [searchPokemonName] is given, fetch initial list.
  /// Otherwise, search for a specific Pokemon.
  void _fetchInitialPokemonList() async {
    // simplePokemonList only contains the name and detailsUrl of each Pokemon.
    // We fetch the details (types, image, etc.) after fetching simplePokemonList.
    final simplePokemonList = await fetchPokemonListService();
    _pokemonList =
        await fetchPokemonDetailsListService(simplePokemonList);

    setState(() {
      _isLoading = false;
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
            onPressed: _onPressSearchIcon,
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
            if (_isLoading)
              Expanded(child: Center(child: CircularProgressIndicator()))
            else
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 250,
                    childAspectRatio: 3 / 2,
                  ),
                  itemCount: !_hasSearched ? _pokemonList.length : _searchResultList.length,
                  itemBuilder: (context, index) {
                    if (!_hasSearched) {
                      Pokemon pokemon = _pokemonList[index];
                      return PokemonListCard(pokemon);
                    } else {
                      Pokemon pokemon = _searchResultList[index];
                      return PokemonListCard(pokemon);
                    }
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _performSearch(String searchText) async {
    print('searchText=$searchText');
    setState(() {
      _isLoading = true;
    });

    final tempPokemonList = await _fetchSearchPokemonList(searchText);
    setState(() {
      _hasSearched = true;
      _searchResultList = tempPokemonList;
      _isLoading = false;
    });
  }


  Future<List<Pokemon>> _fetchSearchPokemonList(String searchText) async {
    return await fetchSearchPokemonListService(searchText);
  }
}


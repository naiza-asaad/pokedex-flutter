import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/models/simple_pokemon_list.dart';
import 'package:pokedex/pages/pokemon_list_page/pokemon_list_card.dart';
import 'package:pokedex/services/pokedex_api_service.dart';

class PokemonListPage extends StatefulWidget {
  static const String route = '/';

  @override
  _PokemonListPageState createState() => _PokemonListPageState();
}

class _PokemonListPageState extends State<PokemonListPage> {
  SimplePokemonList _simplePokemonList;
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

  var _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchInitialPokemonList();

    _scrollController.addListener(_handleScroll);

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

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
                  controller: _scrollController,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 250,
                    childAspectRatio: 3 / 2,
                  ),
                  itemCount: !_hasSearched
                      ? _simplePokemonList.pokemonList.length
                      : _searchResultList.length,
                  itemBuilder: (context, index) {
                    if (!_hasSearched) {
                      Pokemon pokemon = _simplePokemonList.pokemonList[index];
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

  /// Fetches initial list and search Pokemon list.
  /// If [searchPokemonName] is given, fetch initial list.
  /// Otherwise, search for a specific Pokemon.
  void _fetchInitialPokemonList() async {
    // simplePokemonList only contains the name and detailsUrl of each Pokemon.
    // We fetch the details (types, image, etc.) after fetching simplePokemonList.
    _simplePokemonList = await fetchPokemonListService();
//    _simplePokemonList =
//        await fetchPokemonDetailsListService(simplePokemonList);

    setState(() {
      _isLoading = false;
    });
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

  void _handleScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // At the bottom of the list
      print('tried to scroll down at the bottom');

      _loadMorePokemon();
    }
//    if (_scrollController.position.atEdge) {
//      if (_scrollController.position.pixels == 0) {
//        // At the top of the list
//        print('tried to scroll up at the top');
//      } else {
//        // At the bottom of the list
//        print('tried to scroll down at the bottom');
//      }
//    }
  }

  /// Loads more Pokemon list and appends to current list.
  void _loadMorePokemon() async {
    final nextPageUrl = _simplePokemonList.next;
    print('next page url=$nextPageUrl');

    final simplePokemonList = await loadMorePokemonService(
      nextPageUrl: nextPageUrl,
      oldSimplePokemonList: _simplePokemonList,
    );

    setState(() {
      _isLoading = false;
    });
  }
}

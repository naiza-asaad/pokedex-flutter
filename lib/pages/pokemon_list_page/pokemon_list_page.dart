import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/models/simple_pokemon_list.dart';
import 'package:pokedex/pages/pokemon_list_page/pokemon_list_card.dart';
import 'package:pokedex/services/pokemon_list_service.dart';
import 'package:pokedex/services/pokemon_service.dart';
import 'package:pokedex/utilities/global_constants.dart';

class PokemonListPage extends StatefulWidget {
  static const String route = '/';

  @override
  _PokemonListPageState createState() => _PokemonListPageState();
}

class _PokemonListPageState extends State<PokemonListPage> {
  SimplePokemonList _simplePokemonList;

  List<Pokemon> _searchResultList = [];
  bool _isLoading = true;
  bool _hasSearched = false;
  bool _isLoadingMorePokemon = false;

  final _filter = TextEditingController();
  Widget _appBarTitle;
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
  }

  @override
  void didChangeDependencies() {
    _appBarTitle = Text(
      'Pokedex',
      style: Theme.of(context).textTheme.headline2,
    );
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

    super.didChangeDependencies();
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
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _onPressRefreshIcon,
          )
        ],
      ),
      body: Padding(
        padding: kPokemonListPageScaffoldBodyPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isLoading)
              Expanded(child: Center(child: CircularProgressIndicator()))
            else
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _handleRefresh,
                  child: CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      SliverGrid(
                        gridDelegate: kPokemonGridDelegate,
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            if (!_hasSearched) {
                              Pokemon pokemon =
                                  _simplePokemonList.pokemonList[index];
                              return PokemonListCard(pokemon);
                            } else {
                              if ((_searchResultList == null ||
                                  _searchResultList.length <= 0)) {
                                print('no results found');
                                return Center(child: Text('No Pokemon found'));
                              } else {
                                print('found a pokemon');
                                Pokemon pokemon = _searchResultList[index];
                                return PokemonListCard(pokemon);
                              }
                            }
                          },
                          childCount: !_hasSearched
                              ? _simplePokemonList.pokemonList.length
                              : ((_searchResultList == null ||
                                          _searchResultList.length <= 0) &&
                                      _hasSearched)
                                  ? 1 // If 0, itemBuilder never gets called.
                                  : _searchResultList.length,
                        ),
                      ),
                      _buildProgressIndicatorFooter(),
                    ],
                  ),
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

  void _fetchInitialPokemonList() async {
    // simplePokemonList only contains the name and detailsUrl of each Pokemon.
    // We fetch the details (types, image, etc.) after fetching simplePokemonList.
    _simplePokemonList = await PokemonListService().fetchPokemonList();

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
    return await PokemonService().fetchSearchPokemonList(searchText);
  }

  void _handleScroll() {
    if (!_isLoading &&
        !_isLoadingMorePokemon &&
        _scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
      // At the bottom of the list
      print('tried to scroll down at the bottom');

      setState(() {
        _isLoadingMorePokemon = true;
      });

      _loadMorePokemon();
    }
  }

  /// Loads more Pokemon list and appends to current list.
  void _loadMorePokemon() async {
    final nextPageUrl = _simplePokemonList.next;
    print('next page url=$nextPageUrl');

    final simplePokemonList = await PokemonListService().loadMorePokemon(
      nextPageUrl: nextPageUrl,
      oldSimplePokemonList: _simplePokemonList,
    );

    setState(() {
      _isLoading = false;
      _isLoadingMorePokemon = false;
    });
  }

  void _onPressRefreshIcon() => _handleRefresh();

  Future<void> _handleRefresh() async {
    setState(() {
      _isLoading = true;
    });

    _fetchInitialPokemonList();
  }

  _buildProgressIndicatorFooter() {
    print('build footer');

    if (!_isLoadingMorePokemon) {
      return SliverToBoxAdapter(
        child: SizedBox(
          height: kPokemonListPageFooterHeight,
        ),
      );
    }

    return SliverToBoxAdapter(
      child: Center(
        child: Padding(
          padding: kProgressIndicatorFooterPadding,
          child: SizedBox(
            child: Container(
              child: CircularProgressIndicator(
                  strokeWidth: kProgressIndicatorStrokeWidth),
              width: kProgressIndicatorFooterWidth,
              height: kProgressIndicatorFooterHeight,
            ),
          ),
        ),
      ),
    );
  }
}

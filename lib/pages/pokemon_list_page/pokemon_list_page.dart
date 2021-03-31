import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/models/simple_pokemon_list.dart';
import 'package:pokedex/pages/pokemon_list_page/pokemon_list_card.dart';
import 'package:pokedex/services/pokemon_list_service.dart';
import 'package:pokedex/services/pokemon_service.dart';
import 'package:pokedex/utilities/global_constants.dart';
import 'package:pokedex/widgets/search_widget.dart';

class PokemonListPage extends StatefulWidget {
  static const String route = '/';

  @override
  _PokemonListPageState createState() => _PokemonListPageState();
}

class _PokemonListPageState extends State<PokemonListPage> {
  SimplePokemonList _simplePokemonList;

  bool isLoading = true;
  bool isLoadingMorePokemon = false;

  bool isSearching = false;
  bool hasSearched = false;
  final searchFilter = TextEditingController();
  List<Pokemon> searchResultList = [];
  final Icon searchIcon = const Icon(Icons.search);
  final Icon closeIcon = const Icon(Icons.close);

  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(_handleScroll);

    _fetchInitialPokemonList();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearching
            ? SearchWidget(
                searchBoxHint: 'Search Pokemon',
                searchCallback: _performSearch,
                searchFilter: searchFilter,
              )
            : Text(
                'Pokedex',
                style: Theme.of(context).textTheme.headline2,
              ),
        actions: [
          IconButton(
            icon: isSearching ? Icon(Icons.close) : Icon(Icons.search),
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
            if (isLoading)
              Expanded(child: Center(child: CircularProgressIndicator()))
            else
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _handleRefresh,
                  child: CustomScrollView(
                    controller: scrollController,
                    slivers: [
                      SliverGrid(
                        gridDelegate: kPokemonGridDelegate,
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            if (!hasSearched) {
                              Pokemon pokemon =
                                  _simplePokemonList.pokemonList[index];
                              return PokemonListCard(pokemon);
                            } else {
                              if ((searchResultList == null ||
                                  searchResultList.length <= 0)) {
                                print('no results found');
                                return Center(child: Text('No Pokemon found'));
                              } else {
                                print('found a pokemon');
                                Pokemon pokemon = searchResultList[index];
                                return PokemonListCard(pokemon);
                              }
                            }
                          },
                          childCount: !hasSearched
                              ? _simplePokemonList.pokemonList.length
                              : ((searchResultList == null ||
                                          searchResultList.length <= 0) &&
                                      hasSearched)
                                  ? 1 // If 0, itemBuilder never gets called.
                                  : searchResultList.length,
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
      if (!isSearching) {
        isSearching = true;
      }
      else {
        isSearching = false;
        hasSearched = false;
        searchFilter.clear();
        searchResultList.clear();
      }
    });

  }

  void _fetchInitialPokemonList() async {
    // simplePokemonList only contains the name and detailsUrl of each Pokemon.
    // We fetch the details (types, image, etc.) after fetching simplePokemonList.
    _simplePokemonList = await PokemonListService().fetchPokemonList();

    setState(() {
      isLoading = false;
    });
  }

  void _performSearch(String searchText) async {
    print('searchText=$searchText');
    setState(() {
      isLoading = true;
    });

    final tempPokemonList = await _fetchSearchPokemonList(searchText);
    setState(() {
      hasSearched = true;
      searchResultList = tempPokemonList;
      isLoading = false;
    });
  }

  Future<List<Pokemon>> _fetchSearchPokemonList(String searchText) async {
    return await PokemonService().fetchSearchPokemonList(searchText);
  }

  void _handleScroll() {
    if (!isLoading &&
        !isLoadingMorePokemon &&
        scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
      // At the bottom of the list
      print('tried to scroll down at the bottom');

      setState(() {
        isLoadingMorePokemon = true;
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
      isLoading = false;
      isLoadingMorePokemon = false;
    });
  }

  void _onPressRefreshIcon() => _handleRefresh();

  Future<void> _handleRefresh() async {
    setState(() {
      isLoading = true;
    });

    _fetchInitialPokemonList();
  }

  _buildProgressIndicatorFooter() {
    print('build footer');

    if (!isLoadingMorePokemon) {
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

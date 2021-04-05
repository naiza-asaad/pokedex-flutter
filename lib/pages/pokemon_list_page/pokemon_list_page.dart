import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon/pokemon.dart';
import 'package:pokedex/models/simple_pokemon/simple_pokemon_list.dart';
import 'package:pokedex/pages/pokemon_list_page/pokemon_list_card.dart';
import 'package:pokedex/services/pokemon_list_service.dart';
import 'package:pokedex/services/pokemon_service.dart';
import 'package:pokedex/utilities/global_constants.dart';
import 'package:pokedex/widgets/search_widget.dart';

// TODO: Feedback
// Try to create components/custom widgets.
// Break widgets down as many as possible and should be reasonable
// COMMENT RAEL: this file isn't in format.
class PokemonListPage extends StatefulWidget {
  static const String route = '/';

  @override
  _PokemonListPageState createState() => _PokemonListPageState();
}

class _PokemonListPageState extends State<PokemonListPage> {
  SimplePokemonList simplePokemonList;
  // COMMENT RAEL: doesn't need a value here. initialize the default value on initState() method.
  // bool isLoading;
  // bool isLoadingMorePokemon;
  // bool isSearching;
  // bool hasSearched;
  // TextEditingController searchFilter;
  // ScrollController scrollController;
  bool isLoading = true;
  bool isLoadingMorePokemon = false;

  bool isSearching = false;
  bool hasSearched = false;
  final searchFilter = TextEditingController();
  List<Pokemon> searchResultList = [];
  // COMMENT RAEL: not needed just call these values on where this variables are being called
  final Icon searchIcon = const Icon(Icons.search);
  final Icon closeIcon = const Icon(Icons.close);

  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(handleScroll);

    fetchInitialPokemonList();
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
                searchCallback: performSearch,
                searchFilter: searchFilter,
              )
            : Text(
                'Pokedex',
                style: Theme.of(context).textTheme.headline2,
              ),
        actions: [
          IconButton(
            icon: isSearching ? Icon(Icons.close) : Icon(Icons.search),
            onPressed: onPressSearchIcon,
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: onPressRefreshIcon,
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
                  onRefresh: handleRefresh,
                  child: CustomScrollView(
                    controller: scrollController,
                    slivers: [
                      SliverGrid(
                        gridDelegate: kPokemonGridDelegate,
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            if (!hasSearched) {
                              Pokemon pokemon = simplePokemonList.pokemonList[index];
                              return PokemonListCard(pokemon);
                            } else {
                              if ((searchResultList == null || searchResultList.length <= 0)) {
                                return Center(child: Text('No Pokemon found'));
                              } else {
                                Pokemon pokemon = searchResultList[index];
                                return PokemonListCard(pokemon);
                              }
                            }
                          },
                          childCount: !hasSearched
                              ? simplePokemonList.pokemonList.length
                              : ((searchResultList == null || searchResultList.length <= 0) && hasSearched)
                                  ? 1 // If 0, itemBuilder never gets called.
                                  : searchResultList.length,
                        ),
                      ),
                      buildProgressIndicatorFooter(),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void onPressSearchIcon() {
    setState(() {
      if (!isSearching) {
        isSearching = true;
      } else {
        isSearching = false;
        hasSearched = false;
        searchFilter.clear();
        searchResultList.clear();
      }
    });
  }

  void fetchInitialPokemonList() async {
    // simplePokemonList only contains the name and detailsUrl of each Pokemon.
    // We fetch the details (types, image, etc.) after fetching simplePokemonList.
    simplePokemonList = await PokemonListService.fetchPokemonList();

    setState(() {
      isLoading = false;
    });
  }

  // TODO: Feedback
  // If the user typed more than 1 thousand times, will it perform 1k requests? If so, please
  // use a debounce function where it detects after x milliseconds that the user isn't typing, then do the request
  void performSearch(String searchText) async {
    // COMMENT RAEL: use lambda
    // setState(() => isLoading = true);
    setState(() {
      isLoading = true;
    });

    final tempPokemonList = await fetchSearchPokemonList(searchText);
    setState(() {
      hasSearched = true;
      searchResultList = tempPokemonList;
      isLoading = false;
    });
  }

  // COMMENT RAEL: create a new folder named state then add a folder actions with 
  // file that is named actions.dart put this there. same for the other api calls.
  // NOTE: might be more applicable when async redux is introduced.
  Future<List<Pokemon>> fetchSearchPokemonList(String searchText) async {
    return await PokemonService.fetchSearchPokemonList(searchText);
  }

  void handleScroll() {
    if (!isLoading &&
        !isLoadingMorePokemon &&
        scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      // At the bottom of the list
      // COMMENT RAEL: setState(() => isLoadingMorePokemon = true);
      setState(() {
        isLoadingMorePokemon = true;
      });

      loadMorePokemon();
    }
  }

  /// Loads more Pokemon list and appends to current list.
  void loadMorePokemon() async {
    final nextPageUrl = simplePokemonList.next;
    // COMMENT RAEL: put this on the action file you will create
    await PokemonListService.loadMorePokemon(
      nextPageUrl: nextPageUrl,
      oldSimplePokemonList: simplePokemonList,
    );

    setState(() {
      isLoading = false;
      isLoadingMorePokemon = false;
    });
  }

  void onPressRefreshIcon() => handleRefresh();

  Future<void> handleRefresh() async {
    // COMMENT RAEL: setState(() => isLoading = true);
    setState(() {
      isLoading = true;
    });

    fetchInitialPokemonList();
  }

  // TODO: Feedback
  //  avoid building widgets in methods.
  //  This may not affect for simple implementations but in complex apps,
  //  this could lead to performance issue as widgets might not be properly inserted into the widget tree.
  //  Rather, always prefer creating stateless widgets
  buildProgressIndicatorFooter() {
    // COMMENT RAEL: create a new folder inside pokemon_list_page folder
    // named widgets and create a new file that accepts a boolean and return this widget.
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
              child: CircularProgressIndicator(strokeWidth: kProgressIndicatorStrokeWidth),
              width: kProgressIndicatorFooterWidth,
              height: kProgressIndicatorFooterHeight,
            ),
          ),
        ),
      ),
    );
  }
}

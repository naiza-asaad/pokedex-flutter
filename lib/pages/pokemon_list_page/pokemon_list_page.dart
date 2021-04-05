import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon/pokemon.dart';
import 'package:pokedex/models/simple_pokemon/simple_pokemon_list.dart';
import 'package:pokedex/pages/pokemon_list_page/widgets/pokemon_scroll_grid.dart';
import 'package:pokedex/pages/pokemon_list_page/widgets/pokemon_search_results_grid.dart';
import 'package:pokedex/services/pokemon_list_service.dart';
import 'package:pokedex/services/pokemon_service.dart';
import 'package:pokedex/utilities/global_constants.dart';
import 'package:pokedex/widgets/empty_page_with_message.dart';
import 'package:pokedex/widgets/loading_page_indicator.dart';
import 'package:pokedex/widgets/search_widget.dart';
import 'package:pokedex/widgets/toggle_icon_button.dart';

class PokemonListPage extends StatefulWidget {
  static const String route = '/';

  @override
  _PokemonListPageState createState() => _PokemonListPageState();
}

class _PokemonListPageState extends State<PokemonListPage> {
  SimplePokemonList simplePokemonList;
  bool isLoading;
  bool isLoadingMorePokemon;
  bool isSearching;
  bool hasSearched;
  TextEditingController searchFilter;
  List<Pokemon> searchResultList;
  ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    isLoadingMorePokemon = false;
    isSearching = false;
    hasSearched = false;
    searchFilter = TextEditingController();
    searchResultList = [];
    scrollController = ScrollController();
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
          ToggleIconButton(
            iconIfCondition: Icon(Icons.search),
            otherIcon: Icon(Icons.close),
            condition: !isSearching,
            onPress: onPressSearchIcon,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
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
              Expanded(child: LoadingPage())
            else
              Expanded(
                child: !hasSearched
                    ? RefreshIndicator(
                        onRefresh: handleRefresh,
                        child: PokemonScrollGrid(
                          scrollController: scrollController,
                          isLoadingMorePokemon: isLoadingMorePokemon,
                          simplePokemonList: simplePokemonList,
                        ),
                      )
                    : hasSearchResults()
                        ? PokemonSearchResultsGrid(
                            searchResultList: searchResultList,
                          )
                        : EmptyPageWithMessage(message: 'No Pokemon Found'),
              ),
          ],
        ),
      ),
    );
  }

  bool hasSearchResults() {
    return searchResultList?.isNotEmpty ?? false;
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

    setState(() => isLoading = false);
  }

  // TODO: Feedback
  // If the user typed more than 1 thousand times, will it perform 1k requests? If so, please
  // use a debounce function where it detects after x milliseconds that the user isn't typing, then do the request
  void performSearch(String searchText) async {
    setState(() => isLoading = true);

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
        scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
      // At the bottom of the list
      setState(() => isLoadingMorePokemon = true);
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
    setState(() => isLoading = true);
    fetchInitialPokemonList();
  }
}

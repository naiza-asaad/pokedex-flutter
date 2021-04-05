import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon/pokemon.dart';
import 'package:pokedex/models/simple_pokemon/simple_pokemon_list.dart';
import 'package:pokedex/pages/pokemon_list_page/pokemon_list_card/pokemon_list_card.dart';
import 'package:pokedex/utilities/global_constants.dart';
import 'package:pokedex/widgets/infinite_scroll_grid.dart';

class PokemonScrollGrid extends StatelessWidget {
  const PokemonScrollGrid({
    Key key,
    @required this.scrollController,
    @required this.isLoadingMorePokemon,
    @required this.simplePokemonList,
  }) : super(key: key);

  final ScrollController scrollController;
  final bool isLoadingMorePokemon;
  final SimplePokemonList simplePokemonList;

  @override
  Widget build(BuildContext context) {
    return InfiniteScrollGrid(
      scrollController: scrollController,
      isLoadingMoreData: isLoadingMorePokemon,
      gridDelegate: kPokemonGridDelegate,
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          Pokemon pokemon = simplePokemonList.pokemonList[index];
          return PokemonListCard(pokemon);
        },
        childCount: simplePokemonList.pokemonList.length,
      ),
    );
  }
}

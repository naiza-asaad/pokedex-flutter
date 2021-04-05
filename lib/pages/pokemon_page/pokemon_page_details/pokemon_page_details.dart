import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon/pokemon.dart';
import 'package:pokedex/pages/pokemon_page/pokemon_page_details/about_container/about_container.dart';
import 'package:pokedex/pages/pokemon_page/pokemon_page_details/base_stats_container/base_stats_container.dart';
import 'package:pokedex/pages/pokemon_page/pokemon_page_details/evolution_chain_container/evolution_chain_container.dart';
import 'package:pokedex/pages/pokemon_page/pokemon_page_details/moves_container/moves_container.dart';
import 'package:pokedex/utilities/color_utilities.dart';
import 'package:pokedex/utilities/global_constants.dart';

class PokemonPageDetails extends StatelessWidget {
  const PokemonPageDetails({
    Key key,
    @required this.futurePokemon,
    @required this.pokemonColor,
  }) : super(key: key);

  final Future<Pokemon> futurePokemon;
  final Color pokemonColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: kPokemonPageDetailsFlex,
      child: Container(
        height: MediaQuery.of(context).size.height / 2,
        padding: kPokemonPageDetailsPadding,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: kPokemonPageDetailsBorderRadius,
        ),
        child: FutureBuilder<Pokemon>(
          future: futurePokemon,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return DefaultTabController(
                length: kPokemonPageDetailsTabCount,
                initialIndex: kPokemonPageDetailsDefaultTabIndex,
                child: Column(
                  children: [
                    Container(
                      child: TabBar(
                        labelColor: darken(pokemonColor),
                        indicatorColor: Theme.of(context).indicatorColor,
                        unselectedLabelColor:
                            Theme.of(context).unselectedWidgetColor,
                        tabs: [
                          Tab(text: 'About'),
                          Tab(text: 'Base Stats'),
                          Tab(text: 'Evolution'),
                          Tab(text: 'Moves'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          AboutContainer(
                            pokemon: snapshot.data,
                            pokemonColor: pokemonColor,
                          ),
                          BaseStatsContainer(
                            baseStats: snapshot.data.baseStats,
                            pokemonColor: pokemonColor,
                          ),
                          EvolutionChainContainer(
                              evolutionChain: snapshot.data.evolutionChain),
                          MovesContainer(
                            moveList: snapshot.data.moveList,
                            itemBackgroundColor: pokemonColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

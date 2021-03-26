import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/models/pokemon_evolution_chain.dart';
import 'package:pokedex/services/pokedex_api_service.dart';
import 'package:pokedex/utilities/color_utilities.dart';
import 'package:pokedex/utilities/pokemon_color_picker.dart';
import 'package:pokedex/utilities/string_extension.dart';

class PokemonPage extends StatefulWidget {
  static const String route = '/pokemon';

  final Pokemon pokemon;
  final Color primaryThemeColor;

  const PokemonPage({
    this.pokemon,
    this.primaryThemeColor,
  });

  @override
  _PokemonPageState createState() => _PokemonPageState();
}

class _PokemonPageState extends State<PokemonPage> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      primaryColor: widget.primaryThemeColor,
      pokemon: widget.pokemon,
    );
  }
}

class CustomScaffold extends StatefulWidget {
  final Color primaryColor;
  final Pokemon pokemon;

  CustomScaffold({
    this.primaryColor,
    this.pokemon,
  });

  @override
  _CustomScaffoldState createState() => _CustomScaffoldState();
}

class _CustomScaffoldState extends State<CustomScaffold> {
  Future<Pokemon> futurePokemon;

  @override
  void initState() {
    super.initState();

    futurePokemon = fetchPokemonDetailsService(name: widget.pokemon.name);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      child: Scaffold(
        appBar: AppBar(elevation: 0.0),
        backgroundColor: widget.primaryColor,
        body: Column(
          children: [
            PokemonPageHeader(
              pokemon: widget.pokemon,
            ),
            PokemonPageDetails(futurePokemon: futurePokemon),
          ],
        ),
      ),
      data: ThemeData(
        brightness: Brightness.light,
        primaryColor: widget.primaryColor,
      ),
    );
  }
}

class PokemonPageDetails extends StatelessWidget {
  const PokemonPageDetails({
    Key key,
    @required this.futurePokemon,
  }) : super(key: key);

  final Future<Pokemon> futurePokemon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Container(
        height: MediaQuery.of(context).size.height / 2,
        padding: EdgeInsets.symmetric(horizontal: 5.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: FutureBuilder<Pokemon>(
          future: futurePokemon,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return DefaultTabController(
                length: 4,
                initialIndex: 0,
                child: Column(
                  children: [
                    Container(
                      child: TabBar(
                        labelColor: Colors.indigo,
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
                          AboutContainer(pokemon: snapshot.data),
                          BaseStatsContainer(
                              baseStats: snapshot.data.baseStats),
                          EvolutionChainContainer(
                              evolutionChain: snapshot.data.evolutionChain),
                          Center(child: Text('Tab 4')),
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

class EvolutionChainContainer extends StatefulWidget {
  const EvolutionChainContainer({
    Key key,
    @required this.evolutionChain,
  }) : super(key: key);

  final PokemonEvolutionChain evolutionChain;

  @override
  _EvolutionChainContainerState createState() =>
      _EvolutionChainContainerState();
}

class _EvolutionChainContainerState extends State<EvolutionChainContainer> {
//  List<EvolvesTo> stage2Evolutions;
//  List<EvolvesTo> stage3Evolutions;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
//    // 1st pokemon
//    final basePokemon = widget.evolutionChain.chain.speciesName;
//    print('1st pokemon=$basePokemon');
//
//    // evolution/s of 1st pokemon
//    final stage2Evolutions = widget.evolutionChain.chain.evolutions;
//    final hasStage2Evolutions = stage2Evolutions != null && stage2Evolutions.isNotEmpty;
//    for (var evolution in stage2Evolutions) {
//      print(evolution.speciesName);
//    }
//
//    final hasStage3Evolutions = hasStage2Evolutions && stage2Evolutions[0].evolutions.isNotEmpty;
//    final stage3Evolutions = [];
//    if (hasStage3Evolutions) {
//      for (var evolution in stage2Evolutions) {
//        print(evolution.speciesName);
//        for (var stage3Evolution in evolution.evolutions) {
//          stage3Evolutions.add(stage3Evolution);
//          print(stage3Evolution.speciesName);
//        }
//      }
//    }
    return GridView.count(
      crossAxisCount: 3,
      children: buildGridChildren(widget.evolutionChain),
    );
//
//    if (hasStage3Evolutions) {
//      return GridView.count(
//        crossAxisCount: 3,
//        children: [
//          EvolutionCard(pokemonName: basePokemon),
//          EvolutionCard(pokemonName: basePokemon),
//          EvolutionCard(pokemonName: basePokemon),
//          //
//          stage2Evolutions[0] != null ? EvolutionCard(pokemonName: stage2Evolutions[0].speciesName) : EvolutionCard(pokemonName: 'empty'),
//          stage2Evolutions.length > 1 ? EvolutionCard(pokemonName: stage2Evolutions[1].speciesName) : EvolutionCard(pokemonName: 'empty'),
//          stage2Evolutions.length > 2 ? EvolutionCard(pokemonName: stage2Evolutions[2].speciesName) : EvolutionCard(pokemonName: 'empty'),
//          //
//          hasStage3Evolutions && stage3Evolutions.length > 0 ? EvolutionCard(pokemonName: stage3Evolutions[0].speciesName) : EvolutionCard(pokemonName: 'empty'),
//          hasStage3Evolutions && stage3Evolutions.length > 1 ? EvolutionCard(pokemonName: stage3Evolutions[1].speciesName) : EvolutionCard(pokemonName: 'empty'),
//          hasStage3Evolutions && stage3Evolutions.length > 2 ? EvolutionCard(pokemonName: stage3Evolutions[2].speciesName) : EvolutionCard(pokemonName: 'empty'),
//        ],
//      );
//
//    } else if (hasStage2Evolutions) { // no stage 3 but has stage 2
//      // check if eevee
//
//    } else { // no evolution at all
//
//    }
//
//    return Container();
  }

  List<Widget> buildGridChildren(PokemonEvolutionChain evolutionChain) {
    final stage2Evolutions = evolutionChain.chain.evolutions;
    final hasStage2Evolutions =
        stage2Evolutions != null && stage2Evolutions.isNotEmpty;

    final hasStage3Evolutions = hasStage2Evolutions &&
        stage2Evolutions[0].evolutions != null &&
        stage2Evolutions[0].evolutions.isNotEmpty;
    var stage3Evolutions = [];
    if (hasStage3Evolutions) {
      for (var evolution in stage2Evolutions) {
        for (var stage3Evolution in evolution.evolutions) {
          stage3Evolutions.add(stage3Evolution);
        }
      }
    }

    print('stage 2 evolutions');
    for (var stage2Evolution in stage2Evolutions) {
      print(stage2Evolution.speciesName);
    }
    print('stage 3 evolutions');
    for (var stage3Evolution in stage3Evolutions) {
      print(stage3Evolution.speciesName);
    }

    List<Widget> children = [];

    // I'M SORRY.
    // Displays the evolution chain in a 3x3 grid.
    // Handles ALL cases of branched evolutions.

    // Row 1
    // Column 1
    children.add(EvolutionCard());

    // Column 2
    if (hasStage2Evolutions && stage2Evolutions.length == 2) {
      children.add(EvolutionCard(species: stage2Evolutions[0]));
    } else {
      children.add(EvolutionCard());
    }

    // Column 3
    if (hasStage3Evolutions && stage3Evolutions.length == 2) {
      children.add(EvolutionCard(species: stage3Evolutions[0]));
    } else if (hasStage2Evolutions && stage2Evolutions.length == 3) {
      children.add(EvolutionCard(species: stage2Evolutions[0]));
    } else {
      children.add(EvolutionCard());
    }

    // Row 2
    if (hasStage2Evolutions) {
      // base pokemon
      children.add(EvolutionCard(species: evolutionChain.chain));
    } else {
      children.add(EvolutionCard());
    }

    // Column 2
    if (hasStage2Evolutions &&
        stage2Evolutions.length == 1 &&
        hasStage3Evolutions) {
      children.add(EvolutionCard(species: stage2Evolutions[0]));
    } else if (!hasStage2Evolutions && !hasStage3Evolutions) {
      children.add(EvolutionCard(species: evolutionChain.chain));
    } else {
      children.add(EvolutionCard());
    }

    // Column 3
    if (hasStage3Evolutions && stage3Evolutions.length == 1) {
      children.add(EvolutionCard(species: stage3Evolutions[0]));
    } else if (hasStage2Evolutions && stage2Evolutions.length == 3) {
      children.add(EvolutionCard(species: stage2Evolutions[1]));
    } else if (hasStage2Evolutions &&
        !hasStage3Evolutions &&
        stage2Evolutions.length == 1) {
      children.add(EvolutionCard(species: stage2Evolutions[0]));
    } else {
      children.add(EvolutionCard());
    }

    // Row 3
    // Column 1
    children.add(EvolutionCard());

    // Column 2
    if (hasStage3Evolutions && stage2Evolutions.length == 2) {
      children.add(EvolutionCard(species: stage2Evolutions[1]));
    } else {
      children.add(EvolutionCard());
    }

    // Column 3
    if (hasStage3Evolutions && stage3Evolutions.length == 2) {
      children.add(EvolutionCard(species: stage3Evolutions[1]));
    } else if (hasStage2Evolutions && stage2Evolutions.length == 3) {
      children.add(EvolutionCard(species: stage2Evolutions[2]));
    } else {
      children.add(EvolutionCard());
    }

    return children;
  }
}

class EvolutionCard extends StatelessWidget {
  const EvolutionCard({
    Key key,
    @required this.species,
    this.isHidden,
  }) : super(key: key);

  final EvolvesTo species;
  final bool isHidden;

  @override
  Widget build(BuildContext context) {
    if (species != null) {
      print('name=${species.speciesName},imageUrl=${species.imageUrl}');
    }
    return species != null
        ? Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueAccent),
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
            padding: EdgeInsets.symmetric(vertical: 32.0, horizontal: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(species.speciesName),
                Text(''),
              ],
            ),
          )
        : Container(
            padding: EdgeInsets.symmetric(vertical: 32.0, horizontal: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(''),
                Text(''),
              ],
            ),
          );
  }
}

//class OneEvolutionUI extends StatelessWidget {
//  const OneEvolutionUI({
//    Key key,
//    @required this.evolutions,
//  }) : super(key: key);
//
//  final List<EvolvesTo> evolutions;
//
//  @override
//  Widget build(BuildContext context) {
//    return Row(
//      children: [
//        Icon(Icons.arrow_forward),
////        EvolutionCard(isHidden: true, pokemonName: evolutions[0].speciesName),
//        EvolutionCard(isHidden: false, pokemonName: evolutions[0].speciesName),
////        EvolutionCard(isHidden: true, pokemonName: evolutions[0].speciesName),
//      ],
//    );
//  }
//}
//
//class TwoEvolutionsUI extends StatelessWidget {
//  const TwoEvolutionsUI({
//    Key key,
//    @required this.evolutions,
//  }) : super(key: key);
//
//  final List<EvolvesTo> evolutions;
//
//  @override
//  Widget build(BuildContext context) {
//    return Column(
//      children: [
//        Row(
//          children: [
//            Transform.rotate(
//                angle: -math.pi / 4, child: Icon(Icons.arrow_forward)),
//            EvolutionCard(pokemonName: evolutions[0].speciesName),
//          ],
//        ),
//        Row(
//          children: [
//            Transform.rotate(
//                angle: math.pi / 4, child: Icon(Icons.arrow_forward)),
//            EvolutionCard(pokemonName: evolutions[1].speciesName),
//          ],
//        ),
//      ],
//    );
//  }
//}
//
//class ThreeEvolutionsUI extends StatelessWidget {
//  const ThreeEvolutionsUI({
//    Key key,
//    @required this.evolutions,
//  }) : super(key: key);
//
//  final List<EvolvesTo> evolutions;
//
//  @override
//  Widget build(BuildContext context) {
//    return Column(
//      children: [
//        Row(
//          children: [
//            Transform.rotate(
//                angle: -math.pi / 4, child: Icon(Icons.arrow_forward)),
//            EvolutionCard(
//                isHidden: false, pokemonName: evolutions[0].speciesName),
//          ],
//        ),
//        Row(
//          children: [
//            Icon(Icons.arrow_forward),
//            EvolutionCard(
//                isHidden: false, pokemonName: evolutions[1].speciesName),
//          ],
//        ),
//        Row(
//          children: [
//            Transform.rotate(
//                angle: math.pi / 4, child: Icon(Icons.arrow_forward)),
//            EvolutionCard(
//                isHidden: false, pokemonName: evolutions[2].speciesName),
//          ],
//        ),
//      ],
//    );
//  }
//}
//
//class EightEvolutionsUI extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return Padding(
//      padding: const EdgeInsets.all(32.0),
//      child: Column(
//        children: [
//          Row(
//            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//            children: [
//              Column(
//                children: [
//                  EvolutionCard(),
//                  Transform.rotate(
//                      angle: math.pi / 4, child: Icon(Icons.arrow_back)),
//                ],
//              ),
//              Column(
//                children: [
//                  EvolutionCard(),
//                  Icon(Icons.arrow_upward),
//                ],
//              ),
//              Column(
//                children: [
//                  EvolutionCard(),
//                  Transform.rotate(
//                    angle: -math.pi / 4,
//                    child: Icon(Icons.arrow_forward),
//                  ),
//                ],
//              ),
//            ],
//          ),
//          Row(
//            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//            children: [
//              EvolutionCard(),
//              Icon(Icons.arrow_back),
//              EvolutionCard(),
//              Icon(Icons.arrow_forward),
//              EvolutionCard(),
//            ],
//          ),
//          Row(
//            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//            children: [
//              Column(
//                children: [
//                  Transform.rotate(
//                    angle: math.pi / 4,
//                    child: Icon(Icons.arrow_downward),
//                  ),
//                  EvolutionCard(),
//                ],
//              ),
//              Column(
//                children: [
//                  Icon(Icons.arrow_downward),
//                  EvolutionCard(),
//                ],
//              ),
//              Column(
//                children: [
//                  Transform.rotate(
//                    angle: -math.pi / 4,
//                    child: Icon(Icons.arrow_downward),
//                  ),
//                  EvolutionCard(),
//                ],
//              ),
//            ],
//          ),
//        ],
//      ),
//    );
//  }
//}

class PokemonPageHeader extends StatelessWidget {
  const PokemonPageHeader({
    Key key,
    @required this.pokemon,
  }) : super(key: key);

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 8.0,
        bottom: 8.0,
        left: 16.0,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PokemonName(name: pokemon.name),
                PokemonId(id: pokemon.id),
                PokemonTypeList(typeList: pokemon.typeList),
              ],
            ),
          ),
          Expanded(
            child: Hero(
              tag: 'pokemonImage${pokemon.imageUrl}',
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(pokemon.imageUrl),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EvolutionContainer extends StatefulWidget {
  const EvolutionContainer({
    Key key,
    @required this.speciesUrl,
  }) : super(key: key);

  final String speciesUrl;

  @override
  _EvolutionContainerState createState() => _EvolutionContainerState();
}

class _EvolutionContainerState extends State<EvolutionContainer> {
  bool isLoading = true;
  PokemonEvolutionChain evolutionChain;

  @override
  void initState() {
    fetchEvolutionChain();
  }

  void fetchEvolutionChain() async {
    evolutionChain = await fetchPokemonEvolutionChainService(widget.speciesUrl);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: isLoading
          ? CircularProgressIndicator()
          : Container(child: Text('Got the evolution chain')),
//      child: FutureBuilder(
//        future: null,
//        builder: (context, snapshot) {
//          if (snapshot.connectionState == ConnectionState.done) {
//            return Container(child: Text('Test'));
//          } else {
//            return Center(child: CircularProgressIndicator());
//          }
//        }
//      ),
    );
  }
}

class BaseStatsContainer extends StatelessWidget {
  const BaseStatsContainer({
    Key key,
    @required this.baseStats,
  }) : super(key: key);

  final PokemonBaseStats baseStats;

  List<charts.Series<BaseStats, String>> getData() {
    final data = [
      BaseStats('HP', baseStats.hp),
      BaseStats('Attack', baseStats.attack),
      BaseStats('Defense', baseStats.defense),
      BaseStats('Sp-Atk', baseStats.specialAttack),
      BaseStats('Sp-Def', baseStats.specialDefense),
      BaseStats('Speed', baseStats.speed),
    ];

    return [
      charts.Series<BaseStats, String>(
        id: 'Base Stats',
        domainFn: (BaseStats baseStats, _) => baseStats.statName,
        measureFn: (BaseStats baseStats, _) => baseStats.statValue,
        data: data,
        labelAccessorFn: (BaseStats baseStats, _) => '${baseStats.statValue}',
//        '${baseStats.statName}: ${baseStats.statValue}',
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      getData(),
      vertical: false,
      barRendererDecorator: new charts.BarLabelDecorator<String>(),
      primaryMeasureAxis:
          new charts.NumericAxisSpec(renderSpec: new charts.NoneRenderSpec()),
//       Hide domain axis.
      domainAxis: new charts.OrdinalAxisSpec(
        showAxisLine: false,
      ),
    );
  }
}

class BaseStats {
  final String statName;
  final int statValue;

  BaseStats(this.statName, this.statValue);
}

class AboutContainer extends StatelessWidget {
  const AboutContainer({
    Key key,
    @required this.pokemon,
  }) : super(key: key);

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.count(
        childAspectRatio: 5,
        crossAxisCount: 2,
        children: [
          AboutGridLabel(label: 'Height'),
          AboutGridValue(value: '${pokemon.heightInDecimeters} m'),
          AboutGridLabel(label: 'Weight'),
          AboutGridValue(value: '${pokemon.weightInDecimeters} kg'),
          AboutGridLabel(label: 'Abilities'),
          AboutGridValue(value: getAbilitiesString()),
          AboutGridLabel(label: 'Base Experience'),
          AboutGridValue(value: '${pokemon.baseExperience} xp'),
        ],
      ),
    );
  }

  String getAbilitiesString() {
    var concatenated = StringBuffer();
    final abilityList = pokemon.abilityList;
    for (var i = 0; i < abilityList.length; ++i) {
      concatenated.write(abilityList[i].name);
      if (i < abilityList.length - 1) {
        concatenated.write(', ');
      }
    }
    return concatenated.toString();
  }
}

class AboutGridValue extends StatelessWidget {
  const AboutGridValue({
    Key key,
    @required this.value,
  }) : super(key: key);

  final String value;

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: TextStyle(
        fontSize: 24.0,
      ),
    );
  }
}

class AboutGridLabel extends StatelessWidget {
  const AboutGridLabel({
    Key key,
    @required this.label,
  }) : super(key: key);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 24.0,
        color: Colors.blueGrey,
      ),
    );
  }
}

class PokemonName extends StatelessWidget {
  const PokemonName({
    Key key,
    @required this.name,
  }) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 32.0,
      ),
    );
  }
}

class PokemonId extends StatelessWidget {
  const PokemonId({
    Key key,
    @required this.id,
  }) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    return Text(
      '#${_formatPokemonId(id)}',
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 16.0,
      ),
    );
  }

  /// Display Pokemon ID with left-padded zeroes.
  /// e.g. 0001, 0015, 0324
  /// As of this writing, there are 898 Pokemon, so idWidth = 3.
  static String _formatPokemonId(int id) {
    int idWidth = 3;
    return id.toString().padLeft(idWidth, '0');
  }
}

class PokemonTypeList extends StatelessWidget {
  const PokemonTypeList({
    Key key,
    @required List<PokemonType> typeList,
  })  : _typeList = typeList,
        super(key: key);

  final List<PokemonType> _typeList;

  @override
  Widget build(BuildContext context) {
    if (_typeList.length > 1) {
      // Pokemon has 2 types
      return Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Row(
          children: [
            PokemonTypeName(
              name: _typeList[0].type.name,
              mainTypeName: _typeList[0].type.name,
            ),
            PokemonTypeName(
              name: _typeList[1].type.name,
              mainTypeName: _typeList[0].type.name,
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: PokemonTypeName(
          name: _typeList[0].type.name,
          mainTypeName: _typeList[0].type.name,
        ),
      );
    }
  }
}

class PokemonTypeName extends StatelessWidget {
  const PokemonTypeName({
    Key key,
    @required String name,
    @required String mainTypeName,
  })  : _name = name,
        _mainTypeName = mainTypeName,
        super(key: key);

  final String _name;
  final String _mainTypeName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 4.0,
        horizontal: 12.0,
      ),
      margin: EdgeInsets.only(right: 8.0),
      decoration: BoxDecoration(
        color: lighten(PokemonColorPicker.getColor(_mainTypeName)),
        border: Border.all(
          color: Colors.transparent,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Text(
        _name.inCaps,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14.0,
        ),
      ),
    );
  }
}

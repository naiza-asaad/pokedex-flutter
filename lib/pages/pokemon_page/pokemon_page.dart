import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/models/pokemon_evolution_chain.dart';
import 'package:pokedex/services/pokedex_api_service.dart';
import 'package:pokedex/utilities/color_utilities.dart';
import 'package:pokedex/utilities/global_constants.dart';
import 'package:pokedex/utilities/pokemon_color_picker.dart';
import 'package:pokedex/utilities/string_extension.dart';
import 'package:pokedex/utilities/themes.dart';

class PokemonPage extends StatefulWidget {
  static const String route = '/pokemon';

  final Pokemon pokemon;
  final Color pokemonColor;

  const PokemonPage({
    this.pokemon,
    this.pokemonColor,
  });

  @override
  _PokemonPageState createState() => _PokemonPageState();
}

class _PokemonPageState extends State<PokemonPage> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      primaryColor: widget.pokemonColor,
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
        appBar: AppBar(),
        body: Stack(
          children: [
            Column(
              children: [
                PokemonPageHeader(
                  pokemon: widget.pokemon,
                ),
                PokemonPageDetails(
                  futurePokemon: futurePokemon,
                  pokemonColor: widget.primaryColor,
                ),
              ],
            ),
            if (MediaQuery.of(context).orientation == Orientation.portrait) Align(
              alignment: Alignment.lerp(
                Alignment.topCenter,
                Alignment.center,
                0.25,
              ),
              child: Hero(
                tag: 'pokemonImage${widget.pokemon.imageUrl}',
                child: Container(
                  width: kPokemonPageHeaderImageWidth,
                  height: kPokemonPageHeaderImageHeight,
                  decoration: BoxDecoration(
//                    border: debugBorder,
                    image: DecorationImage(
                      image:
                          CachedNetworkImageProvider(widget.pokemon.imageUrl),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      data: PokedexTheme.themeRegular.copyWith(
        scaffoldBackgroundColor: widget.primaryColor,
        primaryColor: widget.primaryColor,
      ),
//      data: ThemeData(
//        brightness: Brightness.light,
//        primaryColor: widget.primaryColor,
//      ),
    );
  }
}

class PokemonPageHeader extends StatelessWidget {
  const PokemonPageHeader({
    Key key,
    @required this.pokemon,
  }) : super(key: key);

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: kPokemonPageHeaderPadding,
        child: Row(
          children: [
            Expanded(
              flex: kPokemonPageHeaderRow1Flex,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PokemonName(name: pokemon.name),
                  PokemonId(id: pokemon.id),
                  PokemonTypeList(typeList: pokemon.typeList),
                ],
              ),
            ),
            if (MediaQuery.of(context).orientation == Orientation.landscape) Expanded(
              child: Hero(
                tag: 'pokemonImage${pokemon.imageUrl}',
                child: Container(
                  width: kPokemonPageHeaderImageWidth,
                  height: kPokemonPageHeaderImageHeight,
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
      style: Theme.of(context).textTheme.headline1,
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
      '#${formatPokemonId(id)}',
      style: Theme.of(context).textTheme.headline3,
    );
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
        padding: kPokemonPageHeaderTypeListTopPadding,
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
        padding: kPokemonPageHeaderTypeListTopPadding,
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
      padding: kPokemonPageHeaderTypeNamePadding,
      margin: kPokemonPageHeaderTypeNameMargin,
      decoration: BoxDecoration(
        color: lighten(PokemonColorPicker.getColor(_mainTypeName)),
        border: Border.all(
          color: kPokemonTypeBorderColor,
        ),
        borderRadius: kPokemonTypeBorderRadius,
      ),
      child: Text(
        _name.inCaps,
        style: Theme.of(context).textTheme.headline4,
      ),
    );
  }
}

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
                        labelColor: pokemonColor,
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
                          AboutContainer(pokemon: snapshot.data),
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

class MovesContainer extends StatelessWidget {
  const MovesContainer({
    Key key,
    @required this.moveList,
    @required this.itemBackgroundColor,
  }) : super(key: key);

  final List<PokemonMove> moveList;
  final Color itemBackgroundColor;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 8.0, left: 4.0, right: 4.0,),
      child: Wrap(
        direction: Axis.horizontal,
        spacing: kMovesContainerWrapSpacing,
        runSpacing: kMovesContainerWrapRunSpacing,
        children: moveList
            .map((move) => MoveContainerItem(
                  moveName: formatPokemonMoveName(move.name),
                  backgroundColor: itemBackgroundColor,
                ))
            .toList(),
      ),
    );
  }
}

class MoveContainerItem extends StatelessWidget {
  const MoveContainerItem({
    Key key,
    this.moveName,
    this.backgroundColor,
  }) : super(key: key);

  final String moveName;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: kMoveItemPadding,
      color: backgroundColor,
      child: Text(
        moveName,
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }
}

class AboutContainer extends StatelessWidget {
  const AboutContainer({
    Key key,
    @required this.pokemon,
  }) : super(key: key);

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: kAboutContainerPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: kFlavorTextPadding,
              child: Text(
                pokemon.species.flavorTextEntry1,
                style: Theme.of(context).textTheme.headline2.copyWith(
                      fontWeight: FontWeight.normal,
                    ),
              ),
            ),
            Table(
              border: TableBorder.all(),
              columnWidths: const <int, TableColumnWidth>{
                0: IntrinsicColumnWidth(),
                1: FlexColumnWidth(),
              },
              children: <TableRow>[
                TableRow(
                  children: [
                    TableCell(child: AboutGridLabel('Height')),
                    TableCell(
                      child: AboutGridValue(
                          '${pokemon.heightInDecimeters / 10} m'),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(child: AboutGridLabel('Weight')),
                    TableCell(
                      child: AboutGridValue(
                          '${pokemon.weightInDecimeters / 10} kg'),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(child: AboutGridLabel('Abilities')),
                    TableCell(child: AboutGridValue(getAbilitiesString())),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(child: AboutGridLabel('Base Experience')),
                    TableCell(
                        child: AboutGridValue('${pokemon.baseExperience} xp')),
                  ],
                ),
              ],
            ),
          ],
        ),
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

class AboutGridLabel extends StatelessWidget {
  const AboutGridLabel(
    this.label, {
    Key key,
  }) : super(key: key);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: kAboutGridTextPadding,
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyText2,
      ),
    );
  }
}

class AboutGridValue extends StatelessWidget {
  const AboutGridValue(
    this.value, {
    Key key,
  }) : super(key: key);

  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: kAboutGridTextPadding,
      child: Text(
        value,
        style: Theme.of(context).textTheme.bodyText2.copyWith(
              color: Colors.black,
            ),
      ),
    );
  }
}

class BaseStats {
  final String statName;
  final int statValue;

  BaseStats(this.statName, this.statValue);
}

class BaseStatsContainer extends StatelessWidget {
  const BaseStatsContainer({
    Key key,
    @required this.baseStats,
    @required this.pokemonColor,
  }) : super(key: key);

  final PokemonBaseStats baseStats;
  final Color pokemonColor;

  List<charts.Series<BaseStats, String>> getData() {
    final data = [
      BaseStats('HP', baseStats.hp),
      BaseStats('Attack', baseStats.attack),
      BaseStats('Defense', baseStats.defense),
      BaseStats('Sp-Atk', baseStats.specialAttack),
      BaseStats('Sp-Def', baseStats.specialDefense),
      BaseStats('Speed', baseStats.speed),
    ];

    print(
        'color=${pokemonColor.toString().replaceAll('Color(', '').replaceAll(')', '').replaceAll('0x', '')}');

    return [
      charts.Series<BaseStats, String>(
        id: 'Base Stats',
        domainFn: (BaseStats baseStats, _) => baseStats.statName,
        measureFn: (BaseStats baseStats, _) => baseStats.statValue,
        data: data,
        labelAccessorFn: (BaseStats baseStats, _) => '${baseStats.statValue}',
        colorFn: (BaseStats baseStats, _) => charts.Color.fromHex(
            //   code: '#F5AC78',
            // ),
            code:
                '#${pokemonColor.toString().replaceAll("Color(", "").replaceAll(")", "").replaceAll("0xff", "")}'),
        // '${baseStats.statName}: ${baseStats.statValue}',
      ),
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
//    return Center(
//      child: GridView.count(
    return Padding(
      padding: kEvolutionChainContainerPadding,
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: kEvolutionChainGridDimension,
        children: buildGridChildren(widget.evolutionChain),
//      ),
      ),
    );
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
      print(stage2Evolution.pokemonName);
    }
    print('stage 3 evolutions');
    for (var stage3Evolution in stage3Evolutions) {
      print(stage3Evolution.pokemonName);
    }

    List<Widget> children = [];

    // I'M SORRY.
    // Displays the evolution chain in a 3x3 grid.
    // Handles ALL cases of branched evolutions.

    final basePokemon = evolutionChain.chain;
    final isDisplayingEvolutionOfEevee = !hasStage3Evolutions &&
        hasStage2Evolutions &&
        stage2Evolutions.length == 8;

    // ROW 1
    // Column 1
    if (isDisplayingEvolutionOfEevee) {
      children.add(EvolutionCard(
        species: stage2Evolutions[0],
        isArrowVertical: true,
        isArrowOnBottom: true,
        arrowWidget: rotateIcon45Degrees(Icons.arrow_back),
      ));
    } else {
      children.add(EvolutionCard());
    }

    // Column 2
    if (hasStage2Evolutions &&
        stage2Evolutions.length == 2 &&
        hasStage3Evolutions) {
      children.add(EvolutionCard(
        species: stage2Evolutions[0],
        isArrowOnLeft: true,
        arrowWidget: rotateIconMinus45Degrees(Icons.arrow_forward),
      ));
    } else if (isDisplayingEvolutionOfEevee) {
      children.add(EvolutionCard(
          species: stage2Evolutions[1],
          isArrowVertical: true,
          isArrowOnBottom: true,
          arrowWidget: Icon(Icons.arrow_upward)));
    } else if (hasStage2Evolutions && stage2Evolutions.length == 3) {
      children.add(EvolutionCard(
          isArrowOnLeft: true,
          arrowWidget: Icon(
            Icons.arrow_forward,
          )));
    } else if (!hasStage3Evolutions &&
        hasStage2Evolutions &&
        stage2Evolutions.length == 2) {
      children.add(EvolutionCard(
          arrowWidget: Icon(
        Icons.arrow_forward,
      )));
    } else {
      children.add(EvolutionCard());
    }

    // Column 3
    if (hasStage3Evolutions &&
        stage3Evolutions.length == 2 &&
        stage2Evolutions.length == 1) {
      children.add(EvolutionCard(
          species: stage3Evolutions[0],
          isArrowOnLeft: true,
          arrowWidget: rotateIconMinus45Degrees(Icons.arrow_forward)));
    } else if (hasStage3Evolutions &&
        stage3Evolutions.length == 2 &&
        stage2Evolutions.length == 2) {
      children.add(EvolutionCard(
          species: stage3Evolutions[0],
          isArrowOnLeft: true,
          arrowWidget: Icon(Icons.arrow_forward)));
    } else if (hasStage2Evolutions && stage2Evolutions.length == 3) {
      children.add(EvolutionCard(species: stage2Evolutions[0]));
    } else if (hasStage2Evolutions &&
        !hasStage3Evolutions &&
        stage2Evolutions.length == 2) {
      children.add(EvolutionCard(species: stage2Evolutions[0]));
    } else if (isDisplayingEvolutionOfEevee) {
      children.add(EvolutionCard(
        species: stage2Evolutions[2],
        isArrowVertical: true,
        isArrowOnBottom: true,
        arrowWidget: rotateIconMinus45Degrees(Icons.arrow_forward),
      ));
    } else {
      children.add(EvolutionCard());
    }

    // ROW 2
    // Column 1
    if (isDisplayingEvolutionOfEevee) {
      children.add(EvolutionCard(
        species: stage2Evolutions[3],
        isArrowOnLeft: false,
        arrowWidget: Icon(Icons.arrow_back),
      ));
//    } else if (hasStage2Evolutions && (stage2Evolutions.length > 2 || stage3Evolutions.length > 1)) {
    } else if (hasStage2Evolutions &&
        stage2Evolutions.length == 2 &&
        stage3Evolutions.length == 2) {
      children.add(EvolutionCard(
        species: evolutionChain.chain,
      ));
//    } else if (hasStage2Evolutions) {
    } else if (hasStage2Evolutions && !hasStage3Evolutions) {
      children.add(EvolutionCard(
        species: evolutionChain.chain,
      ));
    } else if (hasStage2Evolutions && hasStage3Evolutions) {
      // base pokemon
      children.add(EvolutionCard(
        species: evolutionChain.chain,
        isArrowOnLeft: false,
        arrowWidget: Icon(Icons.arrow_forward),
      ));
    } else {
      children.add(EvolutionCard());
    }

    // Column 2
    if (hasStage2Evolutions &&
        stage2Evolutions.length == 1 &&
        hasStage3Evolutions &&
        stage3Evolutions.length == 2) {
      children.add(EvolutionCard(species: stage2Evolutions[0]));
    } else if (hasStage2Evolutions &&
        stage2Evolutions.length == 1 &&
        hasStage3Evolutions) {
//      children.add(EvolutionCard(species: stage2Evolutions[0]));
      children.add(EvolutionCard(
        species: stage2Evolutions[0],
        isArrowOnLeft: false,
        arrowWidget: Icon(Icons.arrow_forward),
      ));
    } else if (!hasStage2Evolutions && !hasStage3Evolutions) {
      children.add(EvolutionCard(species: evolutionChain.chain));
    } else if (isDisplayingEvolutionOfEevee) {
      // eevee
      children.add(EvolutionCard(
        species: basePokemon,
      ));
    } else if (hasStage2Evolutions && stage2Evolutions.length == 3) {
      children.add(EvolutionCard(
          isArrowOnLeft: true,
          arrowWidget: Icon(
            Icons.arrow_forward,
          )));
    } else if (!hasStage3Evolutions &&
        hasStage2Evolutions &&
        stage2Evolutions.length == 1) {
      children.add(EvolutionCard(
          isArrowOnLeft: true,
          arrowWidget: Icon(
            Icons.arrow_forward,
          )));
    } else {
      children.add(EvolutionCard());
    }

    // Column 3
    if (hasStage3Evolutions && stage3Evolutions.length == 1) {
      children.add(EvolutionCard(
        species: stage3Evolutions[0],
      ));
    } else if (!hasStage2Evolutions && !hasStage3Evolutions) {
    } else if (hasStage2Evolutions && stage2Evolutions.length == 3) {
      children.add(EvolutionCard(
        species: stage2Evolutions[1],
      ));
    } else if (hasStage2Evolutions &&
        !hasStage3Evolutions &&
        stage2Evolutions.length == 1) {
      children.add(EvolutionCard(species: stage2Evolutions[0]));
    } else if (isDisplayingEvolutionOfEevee) {
      children.add(EvolutionCard(
        species: stage2Evolutions[4],
        isArrowOnLeft: true,
        arrowWidget: Icon(Icons.arrow_forward),
      ));
    } else {
      children.add(EvolutionCard());
    }

    // ROW 3
    // Column 1
    if (isDisplayingEvolutionOfEevee) {
      children.add(EvolutionCard(
        species: stage2Evolutions[5],
        isArrowVertical: true,
        isArrowOnBottom: false,
        arrowWidget: rotateIconMinus45Degrees(Icons.arrow_back),
      ));
    } else {
      children.add(EvolutionCard());
    }

    // Column 2
    if (hasStage3Evolutions && stage2Evolutions.length == 2) {
      children.add(EvolutionCard(
        species: stage2Evolutions[1],
        isArrowOnLeft: true,
        arrowWidget: rotateIcon45Degrees(Icons.arrow_forward),
      ));
    } else if (isDisplayingEvolutionOfEevee) {
      children.add(EvolutionCard(
          species: stage2Evolutions[6],
          isArrowVertical: true,
          isArrowOnBottom: false,
          arrowWidget: Icon(Icons.arrow_downward)));
    } else if (hasStage2Evolutions && stage2Evolutions.length == 3) {
      children.add(EvolutionCard(
          isArrowOnLeft: true,
          arrowWidget: Icon(
            Icons.arrow_forward,
          )));
    } else if (!hasStage3Evolutions &&
        hasStage2Evolutions &&
        stage2Evolutions.length == 2) {
      children.add(EvolutionCard(
          arrowWidget: Icon(
        Icons.arrow_forward,
      )));
    } else {
      children.add(EvolutionCard());
    }

    // Column 3
    if (hasStage3Evolutions &&
        stage3Evolutions.length == 2 &&
        stage2Evolutions.length == 1) {
      children.add(EvolutionCard(
          species: stage3Evolutions[1],
          isArrowOnLeft: true,
          arrowWidget: rotateIcon45Degrees(Icons.arrow_forward)));
    } else if (hasStage3Evolutions &&
        stage3Evolutions.length == 2 &&
        stage2Evolutions.length == 2) {
      children.add(EvolutionCard(
          species: stage3Evolutions[1],
          isArrowOnLeft: true,
          arrowWidget: Icon(Icons.arrow_forward)));
    } else if (hasStage2Evolutions && stage2Evolutions.length == 3) {
      children.add(EvolutionCard(
        species: stage2Evolutions[2],
      ));
    } else if (hasStage2Evolutions &&
        !hasStage3Evolutions &&
        stage2Evolutions.length == 2) {
      children.add(EvolutionCard(species: stage2Evolutions[1]));
    } else if (isDisplayingEvolutionOfEevee) {
      children.add(EvolutionCard(
        species: stage2Evolutions[7],
        isArrowVertical: true,
        isArrowOnBottom: false,
        arrowWidget: rotateIcon45Degrees(Icons.arrow_forward),
      ));
    } else {
      children.add(EvolutionCard());
    }

    return children;
  }

  Transform rotateIconMinus45Degrees(IconData iconData) {
    return Transform.rotate(
      angle: -math.pi / 4,
      child: Icon(iconData),
    );
  }

  Transform rotateIcon45Degrees(IconData iconData) {
    return Transform.rotate(
      angle: math.pi / 4,
      child: Icon(iconData),
    );
  }
}

class EvolutionCard extends StatelessWidget {
  const EvolutionCard({
    Key key,
    this.species,
    this.arrowWidget,
    this.isArrowOnLeft,
    this.isArrowOnBottom,
    this.isArrowVertical = false,
  }) : super(key: key);

  final EvolvesTo species;
  final Widget arrowWidget;
  final bool isArrowOnLeft;
  final bool isArrowOnBottom;
  final bool isArrowVertical;

  @override
  Widget build(BuildContext context) {
    if (species != null) {
      return Container(
//        decoration: BoxDecoration(
//          border: Border.all(color: Colors.blueAccent),
//          borderRadius: BorderRadius.all(Radius.circular(5.0)),
//        ),
//        padding: EdgeInsets.symmetric(vertical: 32.0, horizontal: 8.0),
        padding: kEvolutionCardPadding,
        child: Row(
          children: [
            if (isArrowOnLeft != null && isArrowOnLeft)
              Expanded(child: arrowWidget),
            Expanded(
              flex: kEvolutionColumnDetailsFlex,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isArrowVertical && !isArrowOnBottom)
                    Expanded(child: arrowWidget),
                  Expanded(
                    flex: kEvolutionColumnDetailsFlex,
                    child: Container(
                      width: kEvolutionColumnDetailsWidth,
                      height: kEvolutionColumnDetailsHeight,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(species.imageUrl),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '#${formatPokemonId(species.pokemonId)}',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(fontSize: 12.0, color: Colors.black),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      species.pokemonName.inCaps,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(fontSize: 12.0, color: Colors.black),
                    ),
                  ),
                  if (isArrowVertical && isArrowOnBottom)
                    Expanded(child: arrowWidget),
                ],
              ),
            ),
            if (isArrowOnLeft != null && !isArrowOnLeft)
              Expanded(child: arrowWidget)
            else
              Expanded(child: Container()),
          ],
        ),
      );
    } else if (arrowWidget != null) {
      return Container(
        padding: kEvolutionArrowPadding,
        child: Center(child: arrowWidget),
      );
    } else {
      return Container(
        padding: kEvolutionCardEmptyPadding,
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
}

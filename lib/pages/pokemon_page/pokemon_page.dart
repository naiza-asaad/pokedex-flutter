import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/utilities/color_utilities.dart';
import 'package:pokedex/utilities/pokemon_color_picker.dart';
import 'package:pokedex/utilities/string_extension.dart';
import 'package:charts_flutter/flutter.dart' as charts;

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

class CustomScaffold extends StatelessWidget {
  final Color primaryColor;
  final Pokemon pokemon;

  CustomScaffold({
    this.primaryColor,
    this.pokemon,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      child: Scaffold(
        appBar: AppBar(elevation: 0.0),
        backgroundColor: primaryColor,
        body: Column(
          children: [
            Padding(
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
            ),
            Expanded(
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
                child: DefaultTabController(
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
                            AboutContainer(pokemon: pokemon),
                            BaseStatsContainer(baseStats: pokemon.baseStats),
                            Center(
                              child: Text(
                                'Display Tab 3',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Center(
                              child: Text(
                                'Display Tab 4',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      data: ThemeData(
        brightness: Brightness.light,
        primaryColor: primaryColor,
      ),
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
        labelAccessorFn: (BaseStats baseStats, _) =>
            '${baseStats.statValue}',
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
      return PokemonTypeName(
        name: _typeList[0].type.name,
        mainTypeName: _typeList[0].type.name,
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

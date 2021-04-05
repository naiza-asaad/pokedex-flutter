import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon/pokemon_base_stats.dart';
import 'package:pokedex/pages/pokemon_page/pokemon_page_details/base_stats_container/models/base_stat.dart';

class BaseStatsContainer extends StatelessWidget {
  const BaseStatsContainer({
    Key key,
    @required this.baseStats,
    @required this.pokemonColor,
  }) : super(key: key);

  final PokemonBaseStats baseStats;
  final Color pokemonColor;

  List<charts.Series<BaseStat, String>> getData() {
    final data = [
      BaseStat('HP', baseStats.hp),
      BaseStat('Attack', baseStats.attack),
      BaseStat('Defense', baseStats.defense),
      BaseStat('Sp-Atk', baseStats.specialAttack),
      BaseStat('Sp-Def', baseStats.specialDefense),
      BaseStat('Speed', baseStats.speed),
    ];

    return [
      charts.Series<BaseStat, String>(
        id: 'Base Stats',
        domainFn: (BaseStat baseStats, _) => baseStats.statName,
        measureFn: (BaseStat baseStats, _) => baseStats.statValue,
        data: data,
        labelAccessorFn: (BaseStat baseStats, _) => '${baseStats.statValue}',
        colorFn: (BaseStat baseStats, _) => charts.Color.fromHex(
            code:
                '#${pokemonColor.toString().replaceAll("Color(", "").replaceAll(")", "").replaceAll("0xff", "")}'),
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
      // Hide domain axis.
      domainAxis: new charts.OrdinalAxisSpec(
        showAxisLine: false,
      ),
    );
  }
}

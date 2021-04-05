import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon/pokemon.dart';
import 'package:pokedex/pages/pokemon_page/pokemon_page_details/about_container/about_grid_label.dart';
import 'package:pokedex/pages/pokemon_page/pokemon_page_details/about_container/about_grid_value.dart';
import 'package:pokedex/utilities/color_utilities.dart';
import 'package:pokedex/utilities/global_constants.dart';

class AboutContainer extends StatelessWidget {
  const AboutContainer({
    Key key,
    @required this.pokemon,
    @required this.pokemonColor,
  }) : super(key: key);

  final Pokemon pokemon;
  final Color pokemonColor;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: kAboutContainerPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: kFlavorTextPadding,
              child: Padding(
                padding: kFlavorTextPadding,
                child: Text(
                  pokemon.species.flavorTextEntry1,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                        fontWeight: FontWeight.normal,
                        color: darken(pokemonColor),
                      ),
                ),
              ),
            ),
            Table(
              border: TableBorder(
                verticalInside: aboutTableBorderInside(pokemonColor),
                horizontalInside: aboutTableBorderInside(pokemonColor),
                top: aboutTableBorderInside(pokemonColor),
                left: aboutTableBorderInside(pokemonColor),
                right: aboutTableBorderInside(pokemonColor),
                bottom: aboutTableBorderInside(pokemonColor),
              ),
              columnWidths: const <int, TableColumnWidth>{
                0: IntrinsicColumnWidth(),
                1: FlexColumnWidth(),
              },
              children: <TableRow>[
                TableRow(
                  decoration: BoxDecoration(
                    color: pokemonColor,
                  ),
                  children: [
                    TableCell(
                      child: AboutGridLabel(
                        'Height',
                        pokemonColor: pokemonColor,
                      ),
                    ),
                    TableCell(
                      child: AboutGridValue(
                        '${pokemon.heightInDecimeters / 10} m',
                      ),
                    ),
                  ],
                ),
                TableRow(
                  decoration: BoxDecoration(
                    color: lighten(pokemonColor),
                  ),
                  children: [
                    TableCell(
                      child: AboutGridLabel(
                        'Weight',
                        pokemonColor: pokemonColor,
                      ),
                    ),
                    TableCell(
                      child: AboutGridValue(
                        '${pokemon.weightInDecimeters / 10} kg',
                      ),
                    ),
                  ],
                ),
                TableRow(
                  decoration: BoxDecoration(
                    color: pokemonColor,
                  ),
                  children: [
                    TableCell(
                      child: AboutGridLabel(
                        'Abilities',
                        pokemonColor: pokemonColor,
                      ),
                    ),
                    TableCell(
                      child: AboutGridValue(
                        getAbilitiesString(),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  decoration: BoxDecoration(
                    color: lighten(pokemonColor),
                  ),
                  children: [
                    TableCell(
                      child: AboutGridLabel(
                        'Base Experience',
                        pokemonColor: pokemonColor,
                      ),
                    ),
                    TableCell(
                      child: AboutGridValue('${pokemon.baseExperience} xp'),
                    ),
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

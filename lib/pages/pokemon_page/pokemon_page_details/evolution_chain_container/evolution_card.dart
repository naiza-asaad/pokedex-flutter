import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon_evolution/evolves_to.dart';
import 'package:pokedex/utilities/global_constants.dart';
import 'package:pokedex/utilities/string_extension.dart';

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

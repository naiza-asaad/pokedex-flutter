import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon_evolution/pokemon_evolution_chain.dart';
import 'package:pokedex/pages/pokemon_page/pokemon_page_details/evolution_chain_container/evolution_card.dart';
import 'package:pokedex/utilities/global_constants.dart';

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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: kEvolutionChainContainerPadding,
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: kEvolutionChainGridDimension,
        children: buildGridChildren(widget.evolutionChain),
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
    } else if (hasStage2Evolutions &&
        stage2Evolutions.length == 2 &&
        stage3Evolutions.length == 2) {
      children.add(EvolutionCard(
        species: evolutionChain.chain,
      ));
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
      children.add(EvolutionCard(
        species: stage2Evolutions[0],
        isArrowOnLeft: false,
        arrowWidget: Icon(Icons.arrow_forward),
      ));
    } else if (!hasStage2Evolutions && !hasStage3Evolutions) {
      children.add(EvolutionCard(species: evolutionChain.chain));
    } else if (isDisplayingEvolutionOfEevee) {
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

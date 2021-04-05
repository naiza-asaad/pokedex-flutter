import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon/pokemon_move.dart';
import 'package:pokedex/pages/pokemon_page/pokemon_page_details/moves_container/moves_container_item.dart';
import 'package:pokedex/utilities/global_constants.dart';
import 'package:pokedex/utilities/string_extension.dart';

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
      padding: kMovesContainerPadding,
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

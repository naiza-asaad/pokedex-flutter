import 'package:flutter/material.dart';
import 'package:pokedex/utilities/global_constants.dart';

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

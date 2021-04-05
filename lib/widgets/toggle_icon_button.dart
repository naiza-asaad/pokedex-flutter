import 'package:flutter/material.dart';

class ToggleIconButton extends StatelessWidget {
  final Icon iconIfCondition;
  final Icon otherIcon;
  final condition;
  final Function() onPress;

  const ToggleIconButton({
    this.iconIfCondition,
    this.otherIcon,
    this.condition,
    this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return condition
        ? IconButton(icon: iconIfCondition, onPressed: onPress)
        : IconButton(icon: otherIcon, onPressed: onPress);
  }
}

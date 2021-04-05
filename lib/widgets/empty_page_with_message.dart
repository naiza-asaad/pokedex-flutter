import 'package:flutter/material.dart';

class EmptyPageWithMessage extends StatelessWidget {
  final String message;

  const EmptyPageWithMessage({
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(message),
      ),
    );
  }
}

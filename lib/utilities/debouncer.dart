import 'dart:async';

import 'package:flutter/material.dart';

class Debouncer {
  final int milliseconds;
  final VoidCallback action;
  Timer _timer;

  Debouncer({
    this.milliseconds,
    this.action,
  });

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(
      Duration(milliseconds: milliseconds),
      action,
    );
  }
}

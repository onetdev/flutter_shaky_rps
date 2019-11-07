import 'package:flutter/material.dart';
import 'package:shakey_rps/ui/widget/shake_randomizer.dart';

class Game extends StatefulWidget {
  @override
  _Game createState() => _Game();
}

class _Game extends State<Game> {
  ShakeRandomizerMode _mode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(color: const Color(0x27364e)),
          child: Center(
            child: ShakeRandomizer(_mode),
          )),
    );
  }
}

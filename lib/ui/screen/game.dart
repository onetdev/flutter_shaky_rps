import 'package:flutter/material.dart';
import 'package:shakey_rps/ui/widget/shake_randomizer.dart';
import 'package:shakey_rps/ui/widget/source_selector.dart';

class Game extends StatefulWidget {
  @override
  _Game createState() => _Game();
}

class _Game extends State<Game> {
  ShakeResultMode _mode = ShakeResultModes.classic;

  onModeChange(ShakeResultMode mode) {
    setState(() {
      _mode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(color: const Color(0xff27364e)),
      child: SafeArea(
          child: Column(children: [
        Expanded(child: ShakeRandomizer(_mode), flex: 3),
        Expanded(
            child: SourceSelector(
          mode: _mode,
          onChanged: (mode) => onModeChange(mode),
        ))
      ])),
    ));
  }
}

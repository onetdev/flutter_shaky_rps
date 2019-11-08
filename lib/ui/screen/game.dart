import 'package:flutter/material.dart';
import 'package:shaky_rps/ui/widget/shake_randomizer.dart';
import 'package:shaky_rps/ui/widget/source_selector.dart';

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
          color: const Color(0xff27364e),
          child: SafeArea(
            child: ShakeRandomizer(_mode),
          ),
        ),
        bottomNavigationBar: Container(
            //color: const Color(0xff27364e),
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [const Color(0xff27364e), const Color(0xff1f2b3e)],
            )),
            child: SourceSelector(
              mode: _mode,
              onChanged: (mode) => onModeChange(mode),
            )));
  }
}

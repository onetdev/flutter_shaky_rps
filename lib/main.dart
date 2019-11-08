import 'package:flutter/material.dart';
import 'package:shaky_rps/ui/screen/game.dart';

void main() => runApp(ShakingRpsApp());

class ShakingRpsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shakey RPS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Game(),
    );
  }
}

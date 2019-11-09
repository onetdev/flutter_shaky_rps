import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shaky_rps/controllers/shaker.dart';
import 'package:shaky_rps/ui/screen/game.dart';

void main() {
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  return runApp(ShakingRpsApp());
}

class ShakingRpsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var shaker = new Shaker();

    /// Init is async, there might be a solid delay when starting the application.
    shaker.init();

    return MultiProvider(
      providers: [ChangeNotifierProvider(builder: (_) => shaker)],
      child: MaterialApp(
        title: 'Shakey RPS',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Game(),
      ),
    );
  }
}

import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:random_color/random_color.dart';
import 'package:shaky_rps/controllers/shaker.dart';
import 'package:shaky_rps/ui/screen/info.dart';
import 'package:shaky_rps/ui/transition/reveal.dart';
import 'package:shaky_rps/ui/widget/shake_randomizer.dart';
import 'package:shaky_rps/ui/widget/source_selector.dart';
import 'package:shaky_rps/vars/shake_set.dart';

class Game extends StatefulWidget {
  @override
  _Game createState() => _Game();
}

class _Game extends State<Game> {
  ShakeGameSet _gameSet = ShakeGameSets.classic;
  Shaker _shaker;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    _shaker = Provider.of<Shaker>(context);
    _shaker.removeListener(onShakerStateChange);
    _shaker.addListener(onShakerStateChange);

    return Stack(children: [
      Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff27364e),
          elevation: 0,
          actions: [
            Container(
              padding: EdgeInsets.only(right: 20),
              child: IconButton(
                icon: Icon(FontAwesomeIcons.info),
                onPressed: () => openHelp(context),
              ),
            )
          ],
        ),
        body: Container(
            color: const Color(0xff27364e),
            width: deviceSize.width,
            child: ShakeRandomizer(_gameSet)),
        bottomNavigationBar: _buildBottom(),
      ),
      _shaker?.status != ShakeStatus.ACTIVE
          ? Container()
          : _buildFlashingOverlay(deviceSize),
    ]);
  }

  void onShakerStateChange() {
    setState(() {
      /// This will schedule a redraw
    });
  }

  void openHelp(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double diagonal = sqrt(pow(size.width, 2) + pow(size.height, 2));

    Navigator.push(
      context,
      RevealRoute(
        page: Info(),
        centerAlignment: Alignment.topRight,
        maxRadius: diagonal,
      ),
    );
  }

  /// This overlay will be shown if the phone is shaking.
  /// Otherwise should not be applied to the widget tree.
  Widget _buildFlashingOverlay(Size size) {
    return Container(
      color: RandomColor().randomColor(
          colorSaturation: ColorSaturation.highSaturation,
          colorBrightness: ColorBrightness.light
          // colorHue: ColorHue.multiple(colorHues: [ColorHue.red, ColorHue.blue]),
          ),
      child: SizedBox(width: size.width, height: size.height),
    );
  }

  /// Bottom part contains the available game sets.
  /// When game set is changed the corresponding button will be highlighted.
  Widget _buildBottom() {
    return BottomAppBar(
      elevation: 0,
      child: Container(
        //color: const Color(0xff27364e),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [const Color(0xff27364e), const Color(0xff1f2b3e)],
          ),
        ),
        child: SourceSelector(
          mode: _gameSet,
          onChanged: (mode) => onGameSetChange(mode),
        ),
      ),
    );
  }

  /// Event handler for the game set selector.0000
  onGameSetChange(ShakeGameSet mode) {
    setState(() {
      _gameSet = mode;
    });
  }
}

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shaky_rps/controllers/shaker.dart';

class ShakeGameSet {
  const ShakeGameSet(this.name, this.items, this.icon);

  final String name;
  final List<ShakeResult> items;
  final ShakeResult icon;
}

class ShakeGameSets {
  static ShakeGameSet classic = ShakeGameSet(
      'classic',
      [
        ShakeResult(icon: FontAwesomeIcons.handRock, text: 'Rock'),
        ShakeResult(icon: FontAwesomeIcons.handPaper, text: 'Paper'),
        ShakeResult(icon: FontAwesomeIcons.handScissors, text: 'Scissors')
      ],
      ShakeResult(icon: FontAwesomeIcons.handRock, text: 'Classic mode'));

  static ShakeGameSet spock = ShakeGameSet(
      'spock',
      [
        ShakeResult(icon: FontAwesomeIcons.handRock, text: 'Rock'),
        ShakeResult(icon: FontAwesomeIcons.handPaper, text: 'Paper'),
        ShakeResult(icon: FontAwesomeIcons.handScissors, text: 'Scissors'),
        ShakeResult(icon: FontAwesomeIcons.handSpock, text: 'Spock'),
        ShakeResult(icon: FontAwesomeIcons.handLizard, text: 'Lizard')
      ],
      ShakeResult(
          icon: FontAwesomeIcons.handSpock, text: 'Spock and Lizad mode'));

  static ShakeGameSet dice = ShakeGameSet(
      'dice',
      [
        ShakeResult(icon: FontAwesomeIcons.diceOne, text: 'One'),
        ShakeResult(icon: FontAwesomeIcons.diceTwo, text: 'Two'),
        ShakeResult(icon: FontAwesomeIcons.diceThree, text: 'Three'),
        ShakeResult(icon: FontAwesomeIcons.diceFour, text: 'Four'),
        ShakeResult(icon: FontAwesomeIcons.diceFive, text: 'Five'),
        ShakeResult(icon: FontAwesomeIcons.diceSix, text: 'Six'),
      ],
      ShakeResult(icon: FontAwesomeIcons.diceSix, text: 'Dice mode'));

  static Map<String, ShakeGameSet> getModes() {
    var result = Map<String, ShakeGameSet>();
    result['classic'] = classic;
    result['spock'] = spock;
    result['dice'] = dice;

    return result;
  }
}

class ShakeResult {
  ShakeResult({this.icon, this.text});

  final IconData icon;
  final String text;
}

class ShakeRandomizer extends StatefulWidget {
  ShakeRandomizer(this.mode, {Key key}) : super(key: key);

  final ShakeGameSet mode;

  @override
  _ShakeRandomizer createState() => _ShakeRandomizer();
}

class _ShakeRandomizer extends State<ShakeRandomizer> {
  math.Random _random = new math.Random();
  ShakeResult _lastRoll;
  Shaker _shaker;

  @override
  void initState() {
    super.initState();
  }

  void onShakeStateChange() {
    if (_shaker.status != ShakeStatus.cooldown) return;

    int result = _random.nextInt(widget.mode.items.length);
    setState(() {
      _lastRoll = widget.mode.items[result];
    });
  }

  void onResultTap() {
    setState(() {
      _lastRoll = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    _shaker = Provider.of<Shaker>(context);
    _shaker.addListener(onShakeStateChange);

    return LayoutBuilder(builder: (context, constraints) {
      Orientation currentOrientation = MediaQuery.of(context).orientation;
      if (currentOrientation == Orientation.portrait) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [_buildInstruction(), _buildValue()],
        );
      } else {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [_buildInstruction(), _buildValue()],
        );
      }
    });
  }

  Widget _buildInstruction() {
    return Text(
      "Shake me!",
      style: TextStyle(
        fontSize: 50,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildValue() {
    if (_lastRoll == null) {
      return Container();
    }

    return GestureDetector(
        onTap: () => onResultTap(),
        child: Icon(
          _lastRoll?.icon,
          color: const Color(0xfff43960),
          size: 80.0,
          semanticLabel: _lastRoll?.text,
        ));
  }

  @override
  void dispose() {
    _shaker?.removeListener(onShakeStateChange);
    super.dispose();
  }
}

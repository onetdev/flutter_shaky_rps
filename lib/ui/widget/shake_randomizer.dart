import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shake/shake.dart';
import 'dart:async';
import 'dart:math' as math;

class ShakeResultMode {
  const ShakeResultMode(this.name, this.items, this.icon);

  final String name;
  final List<ShakeResult> items;
  final ShakeResult icon;
}

class ShakeResultModes {
  static ShakeResultMode classic = ShakeResultMode(
      'classic',
      [
        ShakeResult(icon: FontAwesomeIcons.handRock, text: 'Rock'),
        ShakeResult(icon: FontAwesomeIcons.handPaper, text: 'Paper'),
        ShakeResult(icon: FontAwesomeIcons.handScissors, text: 'Scissors')
      ],
      ShakeResult(icon: FontAwesomeIcons.handRock, text: 'Rock'));

  static ShakeResultMode spock = ShakeResultMode(
      'spock',
      [
        ShakeResult(icon: FontAwesomeIcons.handRock, text: 'Rock'),
        ShakeResult(icon: FontAwesomeIcons.handPaper, text: 'Paper'),
        ShakeResult(icon: FontAwesomeIcons.handScissors, text: 'Scissors'),
        ShakeResult(icon: FontAwesomeIcons.handSpock, text: 'Spock'),
        ShakeResult(icon: FontAwesomeIcons.handLizard, text: 'Lizard')
      ],
      ShakeResult(icon: FontAwesomeIcons.handSpock, text: 'Spock'));

  static ShakeResultMode dice = ShakeResultMode(
      'dice',
      [
        ShakeResult(icon: FontAwesomeIcons.diceOne, text: 'One'),
        ShakeResult(icon: FontAwesomeIcons.diceTwo, text: 'Two'),
        ShakeResult(icon: FontAwesomeIcons.diceThree, text: 'Three'),
        ShakeResult(icon: FontAwesomeIcons.diceFour, text: 'Four'),
        ShakeResult(icon: FontAwesomeIcons.diceFive, text: 'Five'),
        ShakeResult(icon: FontAwesomeIcons.diceSix, text: 'Six'),
      ],
      ShakeResult(icon: FontAwesomeIcons.diceSix, text: 'Six'));

  static Map<String, ShakeResultMode> getModes() {
    var result = Map<String, ShakeResultMode>();
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

  final ShakeResultMode mode;

  @override
  _ShakeRandomizer createState() => _ShakeRandomizer();
}

class _ShakeRandomizer extends State<ShakeRandomizer> {
  bool _shaking = false;
  math.Random _random = new math.Random();
  ShakeResult _lastRoll;
  ShakeDetector _detector;
  Timer _stopTimer;

  @override
  void didChangeDependencies() {
    print('WHO');
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _detector = ShakeDetector.autoStart(
        onPhoneShake: () => onShake(), shakeSlopTimeMS: 300);

    super.initState();
  }

  void onShake() {
    setState(() {
      _lastRoll = null;
      _shaking = true;
      _stopTimer?.cancel();
      _stopTimer = Timer(Duration(milliseconds: 300), () => onShakeStop());
    });
  }

  void onShakeStop() {
    setState(() {
      _stopTimer = null;
      _shaking = false;
      int result = _random.nextInt(widget.mode.items.length);
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
      _shaking ? "Don't break me!" : "Shake me!",
      style: TextStyle(
          fontSize: 50, color: Colors.white, fontWeight: FontWeight.bold),
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
    _detector?.stopListening();
    super.dispose();
  }
}

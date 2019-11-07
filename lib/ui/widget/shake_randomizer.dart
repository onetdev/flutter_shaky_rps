import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shake/shake.dart';
import 'dart:async';
import 'dart:math' as math;

enum ShakeRandomizerMode { classic, spock, dice }

class RollValue {
  RollValue({this.icon, this.text});

  final IconData icon;
  final String text;
}

class ShakeRandomizer extends StatefulWidget {
  ShakeRandomizer(this.mode, {Key key}) : super(key: key);

  final ShakeRandomizerMode mode;

  @override
  _ShakeRandomizer createState() => _ShakeRandomizer();
}

class _ShakeRandomizer extends State<ShakeRandomizer> {
  bool _shaking = false;
  math.Random _random = new math.Random();
  RollValue _lastRoll;
  ShakeDetector _detector;
  Timer _stopTimer;

  @override
  void initState() {
    _detector = ShakeDetector.autoStart(
        onPhoneShake: () => onShake(), shakeSlopTimeMS: 300);

    super.initState();
  }

  onShake() {
    setState(() {
      _lastRoll = null;
      _shaking = true;
      _stopTimer?.cancel();
      _stopTimer = Timer(Duration(milliseconds: 300), () => onShakeStop());
    });
  }

  onShakeStop() {
    setState(() {
      _stopTimer = null;
      _shaking = false;
      int result = _random.nextInt(3);
      print(result);
      if (result == 0)
        _lastRoll =
            RollValue(icon: FontAwesomeIcons.solidHandRock, text: 'Rock');
      if (result == 1)
        _lastRoll =
            RollValue(icon: FontAwesomeIcons.solidHandPaper, text: 'Paper');
      if (result == 2)
        _lastRoll = RollValue(
            icon: FontAwesomeIcons.solidHandScissors, text: 'Scissors');
    });
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, constraints) {
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
      _shaking ? "OH BOI\nI'M SHAKING" : "Shake it bro",
      style: TextStyle(fontSize: 50),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildValue() {
    return Icon(
      _lastRoll?.icon,
      color: Colors.red,
      size: 80.0,
      semanticLabel: _lastRoll?.text,
    );
  }

  @override
  void dispose() {
    _detector?.stopListening();
    super.dispose();
  }
}

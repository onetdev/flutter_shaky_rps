import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shaky_rps/controllers/shaker.dart';
import 'package:shaky_rps/vars/shake_set.dart';

enum ShakeRandomizerStatus {
  HIDDEN,
  BECOMING_VISIBLE,
  VISIBLE,
  BECOMING_INVISIBLE
}

class ShakeRandomizer extends StatefulWidget {
  ShakeRandomizer(this.mode, {Key key}) : super(key: key);

  final ShakeGameSet mode;

  @override
  _ShakeRandomizer createState() => _ShakeRandomizer();
}

class _ShakeRandomizer extends State<ShakeRandomizer>
    with TickerProviderStateMixin {
  /// Will be used for random value and particle angle calculations.
  math.Random _random;

  /// Holds the last result (even after type change.)
  ShakeResult _lastRoll;

  /// The current animation state of the UI.
  ShakeRandomizerStatus _status;

  /// Provides shake events through ChangeNotifier.
  Shaker _shaker;

  /// The base angle of particles coming out of the element.
  /// The number of particles is always (set.length - 1)
  double _particlesAngle;

  /// Animation controllers for the various segments of the animation.
  AnimationController _resultInAnimationController;
  AnimationController _resultOutAnimationController;
  AnimationController _particlesAnimationController;
  AnimationController _wiggleAnimationController;
  Animation _resultInAnimation;
  Animation _resultOutAnimation;
  Animation _particlesAnimation;
  Animation _wiggleAnimation;

  /// Creating animations controllers and state updaters.
  /// Lines with empty setState() expression are the for only marking the
  /// widget as "must rebuild".
  @override
  void initState() {
    super.initState();
    _random = math.Random();
    _status = ShakeRandomizerStatus.HIDDEN;

    /// Handles result appearing and also when it's completed particles
    /// animation will also be drawn onto the screen.
    _resultInAnimationController = new AnimationController(
      vsync: this,
      duration: new Duration(milliseconds: 200),
    );
    _resultInAnimation = new CurvedAnimation(
      parent: _resultInAnimationController,
      curve: Curves.easeOut,
    );
    _resultInAnimation.addListener(() => setState(() {}));
    _resultInAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _status = ShakeRandomizerStatus.VISIBLE;
        _particlesAnimationController.forward(from: 0.0);
      }
    });

    /// Handles disappearing of the result element.
    _resultOutAnimationController = new AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100),
    );
    _resultOutAnimation = new CurvedAnimation(
      parent: _resultOutAnimationController,
      curve: Curves.easeOut,
    );
    _resultOutAnimation.addListener(() => setState(() {}));
    _resultOutAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _status = ShakeRandomizerStatus.HIDDEN;
      }
    });

    /// This will handle the animation when the results are in their place.
    /// The items that are not equal to the result will be splattered.
    /// Particles only depends on result completion but will be independent
    /// from anything else.
    _particlesAnimationController = new AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    _particlesAnimation = new CurvedAnimation(
        parent: _particlesAnimationController, curve: Curves.easeIn);
    _particlesAnimation.addListener(() => setState(() {}));

    /// Shake the instruction text for 1-3 times every 10-15 seconds.
    /// The first will be delayed and the UI will be repainted on value
    /// change.
    _wiggleAnimationController = new AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100),
    );
    _wiggleAnimation = new CurvedAnimation(
      parent: _wiggleAnimationController,
      curve: Curves.easeInOutBack,
    );
    _wiggleAnimation.addListener(() => setState(() {}));
    _wiggleAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _wiggleAnimationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        if (_random.nextInt(3) == 1)
          scheduleInstructionShake();
        else
          _wiggleAnimationController.forward();
      }
    });

    scheduleInstructionShake();
  }

  @override
  void dispose() {
    _shaker?.removeListener(onShakeStateChange);
    _resultInAnimationController.dispose();
    _resultOutAnimationController.dispose();
    _particlesAnimationController.dispose();
    _wiggleAnimationController.dispose();
    super.dispose();
  }

  /// Schedule a instruction label shake between 10 and 15 seconds.
  void scheduleInstructionShake() {
    Timer(Duration(seconds: 10 + _random.nextInt(5)), () {
      _wiggleAnimationController?.forward(from: 0);
    });
  }

  /// Handles shake event and starts the animation controllers.
  ///
  /// The handler will only act if the shake progress is not in a cooldown
  /// and various animation variables will be animated here too.
  void onShakeStateChange() {
    if (_shaker.status != ShakeStatus.COOLDOWN) return;

    int result = _random.nextInt(widget.mode.items.length);
    setState(() {
      _lastRoll = widget.mode.items[result];
      _particlesAngle = _random.nextDouble() * (2 * math.pi);
      _status = ShakeRandomizerStatus.BECOMING_VISIBLE;
      _resultInAnimationController.forward(from: 0.0);
    });
  }

  void onResultTap() {
    if (_status != ShakeRandomizerStatus.VISIBLE) return;

    setState(() {
      _status = ShakeRandomizerStatus.BECOMING_INVISIBLE;
      _resultOutAnimationController.forward(from: 0);
    });
  }

  /// This will show the instruction label above the results
  /// This also has an animation so it wiggles from time to time.
  Widget _buildInstruction() {
    return Container(
      key: ValueKey('roll_instruction'),
      child: Transform.rotate(
        angle: _wiggleAnimationController.value * 3 * math.pi / 180,
        child: Text(
          "Shake me!",
          style: TextStyle(
            fontSize: 50,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildValue() {
    double sizeFactor = 0;
    double opacityFactor = 0;
    double heightFactor = 0;

    if (_status == ShakeRandomizerStatus.BECOMING_VISIBLE) {
      sizeFactor = 4 - (3 * _resultInAnimation.value);
      opacityFactor = _resultInAnimation.value;
      heightFactor = 1;
    } else if (_status == ShakeRandomizerStatus.BECOMING_INVISIBLE) {
      sizeFactor = 1;
      opacityFactor = 1 - _resultOutAnimation.value;
      heightFactor = 1 - _resultOutAnimation.value;
    } else if (_status == ShakeRandomizerStatus.VISIBLE) {
      sizeFactor = 1;
      opacityFactor = 1;
      heightFactor = 1;
    }

    return Transform.scale(
      scale: sizeFactor,
      key: ValueKey('roll_icon_container'),
      child: Container(
        height: 80.0 * heightFactor,
        child: Opacity(
          opacity: opacityFactor,
          child: GestureDetector(
            onTap: () => onResultTap(),
            child: Icon(
              _lastRoll?.icon,
              color: const Color(0xfff43960),
              size: 80.0,
              semanticLabel: _lastRoll?.text,
            ),
          ),
        ),
      ),
    );
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
}

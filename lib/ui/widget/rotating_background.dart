import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RotatingBackground extends StatefulWidget {
  @override
  _RotatingBackground createState() => _RotatingBackground();
}

class _RotatingBackground extends State<RotatingBackground>
    with TickerProviderStateMixin {
  AnimationController _revolverAnimationController;

  @override
  void initState() {
    super.initState();

    _revolverAnimationController = new AnimationController(
      vsync: this,
      duration: new Duration(seconds: 5),
    );
    _revolverAnimationController.addListener(() => setState(() {}));
    _revolverAnimationController.addStatusListener((status) {
      print(status);
      if (status == AnimationStatus.completed) {
        _revolverAnimationController.forward(from: 0);
      } else if (status == AnimationStatus.dismissed) {
        _revolverAnimationController.forward();
      }
    });
    _revolverAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double diagonal =
        math.sqrt(math.pow(size.width, 2) + math.pow(size.height, 2));

    return Positioned(
      top: (diagonal - size.height) / -2,
      left: (diagonal - size.width) / -2,
      width: diagonal,
      height: diagonal,
      child: Transform.rotate(
        // scale: 1 +  _revolverAnimationController.value,
        angle: _revolverAnimationController.value * 360 * math.pi / 180,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.contain,
              image: AssetImage("assets/images/main_bg.jpg"),
            ),
          ),
        ),
      ),
    );
  }
}

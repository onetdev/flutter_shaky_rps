import 'dart:async';
import "package:flutter/material.dart";
import 'package:shake/shake.dart' as parent;

typedef ShakeStatusCallback = Function(ShakeStatus status);
enum ShakeStatus { shaking, waiting, standing }

class Shaker with ChangeNotifier {
  init() async {
    _detector = parent.ShakeDetector.autoStart(
      onPhoneShake: () => onShake(),
      shakeSlopTimeMS: 25,
      shakeThresholdGravity: 2.0,
      shakeCountResetTime: 1500,
    );
  }

  parent.ShakeDetector _detector;
  Timer _stopTimer;
  ShakeStatus status;

  int get counter => _detector.mShakeCount;

  void onShake() {
    print('onshake. c:' + counter.toString());
    _stopTimer?.cancel();
    _stopTimer = Timer(Duration(milliseconds: 300), () => onStop());
    status = ShakeStatus.shaking;
    if (counter < 2) {
      notifyListeners();
    }
  }

  void onStop() {
    _stopTimer = null;
    status = ShakeStatus.standing;
    notifyListeners();
  }

  @override
  void dispose() {
    _detector?.stopListening();
    super.dispose();
  }
}

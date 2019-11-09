import 'dart:async';
import "package:flutter/material.dart";
import 'package:shake/shake.dart' as parent;

typedef ShakeStatusCallback = Function(ShakeStatus status);

/// Active: Potentially ongoing shaking process
/// Inactive: The device is most likely sitting in its place.
/// Locked: The shake is on cooldown
enum ShakeStatus { active, inactive, locked }

/// Implements the shake logic for the application and lettings multiple
/// subscribers know if device movement is detected.
/// Uses Flutter's provide methods in combination with Provider package.
/// Singleton class.
class Shaker with ChangeNotifier {
  Shaker({
    this.cooldown = const Duration(milliseconds: 1000),
    this.timeout = const Duration(milliseconds: 500),
  });

  /// Cooldown after a shake if considered "complete"
  Duration cooldown;

  /// How long will we wait after the last shake to be received before we
  /// consider the shake "complete"
  Duration timeout;

  ShakeStatus status;
  parent.ShakeDetector _detector;
  Timer _stopTimer;
  Timer _cooldownTimer;

  int get counter => _detector.mShakeCount;

  init() async {
    _detector = parent.ShakeDetector.autoStart(
      onPhoneShake: () => onAcceleration(),
      shakeSlopTimeMS: 25,
      shakeThresholdGravity: 2.0,
      shakeCountResetTime: timeout.inMilliseconds,
    );
  }

  /// When the lib detects a decent acceleration in a direction we consider
  /// that a potential shake event.
  /// Since we cannot predict when the user will stop the shaking,
  /// we set a timeout for
  void onAcceleration() {
    print('shaker.onShake. count: ' + counter.toString());
    _cooldownTimer?.cancel();
    _stopTimer?.cancel();
    _stopTimer = Timer(timeout, () => onStop());
    status = ShakeStatus.active;
    notifyListeners();
  }

  void onStop() {
    print('shaker.onStop');
    _cooldownTimer?.cancel();
    _stopTimer = null;
    _stopTimer = Timer(cooldown, () => onCooldownReset());
    status = ShakeStatus.locked;
    notifyListeners();
  }

  void onCooldownReset() {
    _cooldownTimer = null;
    status = ShakeStatus.inactive;
    notifyListeners();
  }

  void stop() {
    _detector?.stopListening();
  }

  @override
  void dispose() {
    stop();
    super.dispose();
  }
}

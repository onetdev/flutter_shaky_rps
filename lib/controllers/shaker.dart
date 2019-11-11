import 'dart:async';
import "package:flutter/material.dart";
import 'package:shaky_rps/utils/shake_detector.dart';

typedef ShakeStatusCallback = Function(ShakeStatus status);

/// Idle: The device is most likely sitting in its place.
/// Active: Potentially ongoing shaking process
/// Cooldown: Shake cannot be started while in this state.
/// Stopped: Detection is halted
enum ShakeStatus { idle, active, cooldown, stopped }

/// Implements the shake logic for the application and lettings multiple
/// subscribers know if device movement is detected.
/// Uses Flutter's provide methods in combination with Provider package.
/// Singleton class.
class Shaker with ChangeNotifier {
  Shaker({
    this.cooldown = const Duration(milliseconds: 1000),
    this.timeout = const Duration(milliseconds: 300),
  });

  /// Cooldown after a shake if considered "complete"
  Duration cooldown;

  /// How long will we wait after the last shake to be received before we
  /// consider the shake "complete"
  Duration timeout;

  ShakeStatus get status => _status;

  ShakeStatus _status = ShakeStatus.stopped;
  ShakeDetector _detector;
  Timer _stopTimer;
  Timer _cooldownTimer;

  init() async {
    _detector = ShakeDetector(() => _onShake());
    start();
    _updateStatus(ShakeStatus.idle);
  }

  /// Updates status and notify all listeners.
  _updateStatus(ShakeStatus status) {
    _status = status;
    notifyListeners();
  }

  /// Captures events from shake detector and if it's not in cooldown period nor
  /// stopped will schedule the timer shake end.
  void _onShake() {
    if (status != ShakeStatus.idle && status != ShakeStatus.active) return;

    _stopTimer?.cancel();
    _stopTimer = Timer(timeout, () => _onStop());

    _updateStatus(ShakeStatus.active);
  }

  /// Schedule cooldown and update state as well
  void _onStop() {
    _stopTimer = null;

    _cooldownTimer?.cancel();
    _cooldownTimer = Timer(cooldown, () => _onCooldownReset());

    _updateStatus(ShakeStatus.cooldown);
  }

  /// Set device to be ready for receiving shakes again.
  void _onCooldownReset() {
    _cooldownTimer = null;

    _updateStatus(ShakeStatus.idle);
  }

  /// Starts the detection
  void start() {
    _detector?.start();
  }

  /// Stops the detection and removes dangling event handlers.
  void stop() {
    _detector?.stop();
  }

  @override
  void dispose() {
    stop();
    super.dispose();
  }
}

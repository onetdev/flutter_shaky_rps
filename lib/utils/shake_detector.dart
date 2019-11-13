import 'dart:async';
import 'package:sensors/sensors.dart';

/// Detects cumulative accelerations
///
/// Inspired from: https://github.com/square/seismic
/// Detects phone shaking. If more than 75% of the samples taken in the past 0.5s are
/// accelerating, the device is a) shaking, or b) free falling 1.84m (h =
/// 1/2*g*t^2*3/4).
class ShakeDetector {
  ShakeDetector(this.onShake, {this.statsEnabled = true});

  static final sensitivityLight = 11;
  static final sensitivityMedium = 13;
  static final sensitivityHard = 15;

  static final defaultAccelerationThreshold = sensitivityMedium;

  /// When the magnitude of total acceleration exceeds this
  /// value, the phone is accelerating.
  var _accelerationThreshold = defaultAccelerationThreshold;

  final Function onShake;
  bool statsEnabled;

  final SampleQueue _queue = new SampleQueue();
  SampleStats _stats;
  StreamSubscription<UserAccelerometerEvent> _listener;

  SampleStats get stats => _stats;

  start() {
    stop();
    if (statsEnabled) {
      _stats = SampleStats();
    }
    _listener = userAccelerometerEvents.listen(onAccelerometerEvent);
  }

  stop() {
    _stats = null;
    _listener?.cancel();
  }

  onAccelerometerEvent(UserAccelerometerEvent event) {
    bool accelerating = isAccelerating(event);
    int timestamp = DateTime.now().microsecondsSinceEpoch;
    _queue.add(timestamp, accelerating);
    if (_queue.isShaking()) {
      if (onShake != null) onShake();
      _queue.clear();
    }

    _stats.increment(accelerating);
  }

  /// Returns true if the device is currently accelerating.
  ///
  /// Instead of comparing magnitude to [_accelerationThreshold],
  /// compare their squares. This is equivalent and doesn't need the
  /// actual magnitude, which would be computed using (expensive) Math.sqrt().
  bool isAccelerating(UserAccelerometerEvent event) {
    final double magnitudeSquared =
        event.x * event.x + event.y * event.y + event.z * event.z;
    return magnitudeSquared > _accelerationThreshold * _accelerationThreshold;
  }
}

class SampleStats {
  /// Optional [startTime] in microseconds.
  SampleStats({int startTime})
      : this._startTime = DateTime.now().microsecondsSinceEpoch;

  int _total = 0;
  int _acceleration = 0;
  int _startTime = 0;

  double get elapsedTime {
    return (DateTime.now().microsecondsSinceEpoch - _startTime).toDouble();
  }

  double get avg => _total / elapsedTime;

  double get avgAcceleration => _acceleration / elapsedTime;

  void increment(bool isAccelerating) {
    _total++;
    _acceleration += isAccelerating ? 1 : 0;
  }

  String toString() {
    return "[avg: ${avg.toString()}, acceleration: ${avgAcceleration.toString()}, elapsed: ${elapsedTime.toString()}]";
  }
}

/// Queue of samples. Keeps a running average.
class SampleQueue {
  /// Window size in microseconds. Used to compute the average.
  static final int _maxWindowSize = 250000; // 0.25s
  static final int _minWindowSize = _maxWindowSize >> 1; // half of max

  /// Ensure the queue size never falls below this size, even if the device
  /// fails to deliver this many events during the time window.
  /// The LG Ally is one such device.
  static final int _minQueueSize = 4;

  final SamplePool _pool = new SamplePool();
  Sample _oldest;
  Sample _newest;
  int _sampleCount = 0;
  int _acceleratingCount = 0;

  /// Adds a sample at [timestamp] in microseconds with [accelerating] set
  /// to true if acceleration value is higher than [accelerationThreshold].
  void add(int timestamp, bool accelerating) {
    /// Purge samples that proceed window.
    purge(timestamp - _maxWindowSize);

    /// Add the sample to the queue.
    Sample added = _pool.acquire();
    added.timestamp = timestamp;
    added.accelerating = accelerating;
    added.next = null;
    if (_newest != null) {
      _newest.next = added;
    }

    _newest = added;
    if (_oldest == null) {
      _oldest = added;
    }

    /// Update running average.
    _sampleCount++;
    if (accelerating) {
      _acceleratingCount++;
    }
  }

  /// Removes all samples from this queue.
  void clear() {
    while (_oldest != null) {
      Sample removed = _oldest;
      _oldest = removed.next;
      _pool.release(removed);
    }
    _newest = null;
    _sampleCount = 0;
    _acceleratingCount = 0;
  }

  /// Purges samples with timestamps older than [cutoff] in microseconds.
  void purge(int cutoff) {
    while (_sampleCount >= _minQueueSize &&
        _oldest != null &&
        cutoff - _oldest.timestamp > 0) {
      /// Remove sample.
      Sample removed = _oldest;
      if (removed.accelerating) {
        _acceleratingCount--;
      }
      _sampleCount--;

      _oldest = removed.next;
      if (_oldest == null) {
        _newest = null;
      }
      _pool.release(removed);
    }
  }

  /// Returns true if we have enough samples and more than 3/4 of those samples
  /// are accelerating.
  bool isShaking() {
    return _newest != null &&
        _oldest != null &&
        _newest.timestamp - _oldest.timestamp >= _minWindowSize &&
        _acceleratingCount >= (_sampleCount >> 1) + (_sampleCount >> 2);
  }
}

/// An accelerometer sample.
class Sample {
  /// Time sample was taken in microseconds
  int timestamp;

  /// If acceleration is larger than [accelerationThreshold]
  bool accelerating;

  /// Next sample in the queue or pool.
  Sample next;
}

/// Pools samples. Avoids garbage collection.
class SamplePool {
  Sample _head;

  /// Acquires a sample from the pool.
  Sample acquire() {
    Sample acquired = _head;
    if (acquired == null) {
      acquired = new Sample();
    } else {
      // Remove instance from pool.
      _head = acquired.next;
    }
    return acquired;
  }

  /// Returns a sample to the pool.
  void release(Sample sample) {
    sample.next = _head;
    _head = sample;
  }
}

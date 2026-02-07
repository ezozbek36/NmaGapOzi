import 'dart:math';

import '../mock_config.dart';

class LatencySimulator {
  final MockProviderConfig config;
  late final Random _random;

  LatencySimulator(this.config) {
    _random = Random(config.seed);
  }

  Future<void> simulate() async {
    if (config.latencyMinMs <= 0 && config.latencyMaxMs <= 0) return;

    final range = config.latencyMaxMs - config.latencyMinMs;
    final delay = config.latencyMinMs + (range > 0 ? _random.nextInt(range) : 0);

    await Future.delayed(Duration(milliseconds: delay));
  }
}

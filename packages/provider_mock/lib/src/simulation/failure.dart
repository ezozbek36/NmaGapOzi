import 'dart:math';

import 'package:provider_api/provider_api.dart';

import '../mock_config.dart';

class FailureSimulator {
  final MockProviderConfig config;
  late final Random _random;

  FailureSimulator(this.config) {
    _random = Random(config.seed);
  }

  void check() {
    if (config.failRate <= 0.0) return;

    if (_random.nextDouble() < config.failRate) {
      throw const NetworkException('Simulated random failure');
    }
  }
}

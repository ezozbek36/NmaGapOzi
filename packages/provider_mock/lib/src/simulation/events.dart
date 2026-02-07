import 'dart:async';

import 'package:provider_api/provider_api.dart';

class EventSimulator {
  final _controller = StreamController<ProviderEvent>.broadcast();

  Stream<ProviderEvent> get events => _controller.stream;

  void emit(ProviderEvent event) {
    _controller.add(event);
  }

  void dispose() {
    _controller.close();
  }
}

class MockProviderConfig {
  final int seed;
  final int conversationCount;
  final int messagesPerConversation;
  final int latencyMinMs;
  final int latencyMaxMs;
  final double failRate;
  final bool simulateTyping;
  final DateTime? baseTime;

  const MockProviderConfig({
    this.seed = 42,
    this.conversationCount = 50,
    this.messagesPerConversation = 100,
    this.latencyMinMs = 100,
    this.latencyMaxMs = 500,
    this.failRate = 0.0,
    this.simulateTyping = false,
    this.baseTime,
  });

  MockProviderConfig copyWith({
    int? seed,
    int? conversationCount,
    int? messagesPerConversation,
    int? latencyMinMs,
    int? latencyMaxMs,
    double? failRate,
    bool? simulateTyping,
    DateTime? baseTime,
  }) {
    return MockProviderConfig(
      seed: seed ?? this.seed,
      conversationCount: conversationCount ?? this.conversationCount,
      messagesPerConversation: messagesPerConversation ?? this.messagesPerConversation,
      latencyMinMs: latencyMinMs ?? this.latencyMinMs,
      latencyMaxMs: latencyMaxMs ?? this.latencyMaxMs,
      failRate: failRate ?? this.failRate,
      simulateTyping: simulateTyping ?? this.simulateTyping,
      baseTime: baseTime ?? this.baseTime,
    );
  }
}

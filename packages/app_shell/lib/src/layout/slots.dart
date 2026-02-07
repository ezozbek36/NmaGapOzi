import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef SlotBuilder = Widget Function(BuildContext context);

class SlotRegistry extends Notifier<int> {
  final Map<String, SlotBuilder> _builders = {};

  @override
  int build() => 0;

  void register(String slotId, SlotBuilder builder) {
    if (_builders.containsKey(slotId)) {
      debugPrint('Warning: Overwriting slot builder for $slotId');
    }
    _builders[slotId] = builder;
    state++;
  }

  void unregister(String slotId) {
    _builders.remove(slotId);
    state++;
  }

  SlotBuilder? getBuilder(String slotId) {
    return _builders[slotId];
  }
}

final slotRegistryProvider = NotifierProvider<SlotRegistry, int>(SlotRegistry.new);

class Slot extends ConsumerWidget {
  final String slotId;
  final Widget? placeholder;

  const Slot({super.key, required this.slotId, this.placeholder});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(slotRegistryProvider);
    final registry = ref.read(slotRegistryProvider.notifier);
    final builder = registry.getBuilder(slotId);

    if (builder != null) {
      return builder(context);
    }

    return placeholder ?? const SizedBox.shrink();
  }
}

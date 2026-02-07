import 'package:flutter/widgets.dart';
import '../theme/app_theme.dart';

enum SplitDirection { horizontal, vertical }

class SplitController extends ChangeNotifier {
  SplitController({double initialSize = 0.5}) : _size = initialSize;

  double _size;
  double get size => _size;

  set size(double value) {
    if (_size != value) {
      _size = value;
      notifyListeners();
    }
  }
}

class ResizableSplit extends StatefulWidget {
  const ResizableSplit({
    super.key,
    required this.direction,
    required this.firstChild,
    required this.secondChild,
    this.controller,
    this.minSize = 0.1,
    this.maxSize = 0.9,
    this.initialSize = 0.5,
    this.handleSize = 8.0,
    this.onChanged,
  });

  final SplitDirection direction;
  final Widget firstChild;
  final Widget secondChild;
  final SplitController? controller;
  final double minSize;
  final double maxSize;
  final double initialSize;
  final double handleSize;
  final ValueChanged<double>? onChanged;

  @override
  State<ResizableSplit> createState() => _ResizableSplitState();
}

class _ResizableSplitState extends State<ResizableSplit> {
  late SplitController _controller;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? SplitController(initialSize: widget.initialSize);
    _controller.addListener(_handleControllerChange);
  }

  @override
  void didUpdateWidget(ResizableSplit oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChange);
      _controller = widget.controller ?? SplitController(initialSize: widget.initialSize);
      _controller.addListener(_handleControllerChange);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleControllerChange);
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _handleControllerChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalSize = widget.direction == SplitDirection.horizontal ? constraints.maxWidth : constraints.maxHeight;

        return Stack(
          children: [
            Positioned.fill(child: _buildChildren(context)),
            _buildHandle(context, totalSize, theme),
          ],
        );
      },
    );
  }

  Widget _buildChildren(BuildContext context) {
    if (widget.direction == SplitDirection.horizontal) {
      return Row(
        children: [
          Expanded(flex: (_controller.size * 1000).toInt(), child: widget.firstChild),
          SizedBox(width: widget.handleSize),
          Expanded(flex: ((1.0 - _controller.size) * 1000).toInt(), child: widget.secondChild),
        ],
      );
    } else {
      return Column(
        children: [
          Expanded(flex: (_controller.size * 1000).toInt(), child: widget.firstChild),
          SizedBox(height: widget.handleSize),
          Expanded(flex: ((1.0 - _controller.size) * 1000).toInt(), child: widget.secondChild),
        ],
      );
    }
  }

  Widget _buildHandle(BuildContext context, double totalSize, AppTheme theme) {
    final offset = _controller.size * totalSize - (widget.handleSize / 2);

    return Positioned(
      left: widget.direction == SplitDirection.horizontal ? offset : 0,
      top: widget.direction == SplitDirection.vertical ? offset : 0,
      width: widget.direction == SplitDirection.horizontal ? widget.handleSize : null,
      height: widget.direction == SplitDirection.vertical ? widget.handleSize : null,
      right: widget.direction == SplitDirection.vertical ? 0 : null,
      bottom: widget.direction == SplitDirection.horizontal ? 0 : null,
      child: MouseRegion(
        cursor: widget.direction == SplitDirection.horizontal ? SystemMouseCursors.resizeLeftRight : SystemMouseCursors.resizeUpDown,
        onEnter: (_) => setState(() => _isHovering = true),
        onExit: (_) => setState(() => _isHovering = false),
        child: GestureDetector(
          onPanUpdate: (details) {
            final delta = widget.direction == SplitDirection.horizontal ? details.delta.dx : details.delta.dy;
            final newSize = (_controller.size * totalSize + delta) / totalSize;
            _controller.size = newSize.clamp(widget.minSize, widget.maxSize);
            widget.onChanged?.call(_controller.size);
          },
          child: Container(
            color: _isHovering ? theme.colors.accent : const Color(0x00000000),
            child: Center(
              child: Container(
                width: widget.direction == SplitDirection.horizontal ? 1 : 20,
                height: widget.direction == SplitDirection.vertical ? 1 : 20,
                color: theme.colors.border,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

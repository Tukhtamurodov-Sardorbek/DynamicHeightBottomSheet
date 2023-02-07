import 'package:dynamicbottomsheet/src/helpers/drag_wrapper.dart';
import 'package:dynamicbottomsheet/src/helpers/scroll_controller_override.dart';
import 'package:dynamicbottomsheet/src/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OverflowPage extends StatelessWidget {
  final Widget child;
  final ScrollController? scrollController;
  final ValueChanged<Size> onSizeChange;
  final Function(double) dragUpdate;
  final VoidCallback dragEnd;

  const OverflowPage({
    required this.child,
    this.scrollController,
    required this.onSizeChange,
    required this.dragUpdate,
    required this.dragEnd,
  });

  @override
  Widget build(BuildContext context) {
    return OverflowBox(
      minHeight: 0,
      minWidth: null,
      maxHeight: double.infinity,
      maxWidth: null,
      alignment: Alignment.topCenter,
      child: SizeNotifier(
        scrollController: scrollController,
        onSizeChange: onSizeChange,
        dragUpdate: dragUpdate,
        dragEnd: dragEnd,
        child: child,
      ),
    );
  }
}

class SizeNotifier extends StatefulWidget {
  final Widget child;
  final ScrollController? scrollController;
  final ValueChanged<Size> onSizeChange;
  final Function(double) dragUpdate;
  final VoidCallback dragEnd;

  const SizeNotifier({
    Key? key,
    required this.child,
    this.scrollController,
    required this.onSizeChange,
    required this.dragUpdate,
    required this.dragEnd,
  }) : super(key: key);

  @override
  _SizeNotifierState createState() => _SizeNotifierState();
}

class _SizeNotifierState extends State<SizeNotifier> {
  final _widgetKey = GlobalKey();
  Size? _oldSize;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _notifySize());
    return NotificationListener<SizeChangedLayoutNotification>(
      onNotification: (_) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _notifySize());
        return true;
      },
      child: SizeChangedLayoutNotifier(
        child: Container(
          key: _widgetKey,
          constraints: BoxConstraints(
            maxHeight: Provider.of<DynamicBottomSheetProvider>(context, listen: false).maxSheetHeight,
          ),
          child: widget.scrollController != null ? scrollableChild() : draggableChild(),
        ),
      ),
    );
  }

  void _notifySize() {
    final context = _widgetKey.currentContext;
    if (context == null) return;
    final size = context.size;
    if (_oldSize != size) {
      _oldSize = size;
      widget.onSizeChange(size!);
    }
  }

  Widget scrollableChild() {
    return ScrollControllerOverride(
      scrollController: widget.scrollController!,
      dragUpdate: widget.dragUpdate,
      dragEnd: widget.dragEnd,
      currentPosition: Provider.of<DynamicBottomSheetProvider>(context, listen: false).currentPosition,
      snappingCalculator: Provider.of<DynamicBottomSheetProvider>(context, listen: false).snappingCalculator,
      child: widget.child,
    );
  }

  Widget draggableChild() {
    return DragWrapper(
      dragEnd: widget.dragEnd,
      dragUpdate: widget.dragUpdate,
      child: widget.child,
    );
  }
}

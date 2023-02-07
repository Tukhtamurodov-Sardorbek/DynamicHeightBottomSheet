import 'package:flutter/material.dart';

class OverflowPage extends StatelessWidget {
  final ValueChanged<Size> onSizeChange;
  final Widget child;

  const OverflowPage({
    required this.onSizeChange,
    required this.child,
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
        onSizeChange: onSizeChange,
        child: child,
      ),
    );
  }
}


class SizeNotifier extends StatefulWidget {
  final Widget child;
  final ValueChanged<Size> onSizeChange;

  const SizeNotifier({
    Key? key,
    required this.child,
    required this.onSizeChange,
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
          child: widget.child,
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
}

import 'package:flutter/material.dart';

class DragWrapper extends StatelessWidget {
  final Widget child;
  final Function(double) dragUpdate;
  final VoidCallback dragEnd;

  const DragWrapper({
    Key? key,
    required this.dragEnd,
    required this.child,
    required this.dragUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){},
      onVerticalDragEnd: (_) {
        dragEnd();
      },
      onVerticalDragUpdate: (dragData) {
        dragUpdate(dragData.delta.dy);
      },
      child: child,
    );
  }
}

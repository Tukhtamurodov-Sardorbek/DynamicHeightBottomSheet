import 'package:dynamicbottomsheet/src/provider/provider.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class ScrollControllerOverride extends StatefulWidget {
  final ScrollController scrollController;
  final Widget child;

  final Function(double) dragUpdate;
  final VoidCallback dragEnd;
  final double currentPosition;

  const ScrollControllerOverride({
    super.key,
    required this.scrollController,
    required this.dragUpdate,
    required this.dragEnd,
    required this.currentPosition,
    required this.child,
  });

  @override
  _ScrollControllerOverrideState createState() => _ScrollControllerOverrideState();
}

class _ScrollControllerOverrideState extends State<ScrollControllerOverride> {
  DragDirection? _currentDragDirection;
  double _currentLockPosition = 0;

  @override
  void initState() {
    super.initState();
    // print('ScrollController InitState');
    // print('PORT RECEIVE: ${widget.scrollController}');
    widget.scrollController.removeListener(_onScrollUpdate);
    widget.scrollController.addListener(_onScrollUpdate);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScrollUpdate);
    super.dispose();
  }

  void _onScrollUpdate() {
    // print('CanScroll: $_allowScrolling | Direction: $_currentDragDirection | CurrentPosition: ${widget.currentPosition} | MaxHeight: ${_biggestSnapPos}');
    if (!_allowScrolling){
      _lockScrollPosition(widget.scrollController);
    }
  }

  void _overrideScroll(double dragAmount) {
    if (!_allowScrolling){
      widget.dragUpdate(dragAmount);
    }
  }

  void _setLockPosition() {
    if (widget.scrollController.hasClients && _currentDragDirection == DragDirection.up) {
      _currentLockPosition = widget.scrollController.position.pixels;
    } else {
      _currentLockPosition = 0;
    }
  }

  double get maxPinPosition => context.read<DynamicBottomSheetProvider>().topPinPosition;
  double get minPinPosition => context.read<DynamicBottomSheetProvider>().bottomPinPosition;

  bool get _allowScrolling {
    if(widget.scrollController.hasClients){
      if (_currentDragDirection == DragDirection.up) {
        if (widget.currentPosition >= maxPinPosition) {
          return true;
        } else {
          return false;
        }
      }
      if (_currentDragDirection == DragDirection.down) {
        if (widget.scrollController.position.pixels > 0) return true;
        if (widget.currentPosition <= minPinPosition) {
          return true;
        } else {
          return false;
        }
      }
    }
    return false;
  }

  void _lockScrollPosition(ScrollController controller) {
    controller.position.setPixels(_currentLockPosition);
  }

  void _setDragDirection(double dragAmount) {
    _currentDragDirection = dragAmount > 0 ? DragDirection.down : DragDirection.up;
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerMove: (dragEvent) {
        final dragValue = dragEvent.delta.dy;
        _setDragDirection(dragValue);
        _setLockPosition();
        _overrideScroll(dragValue);
      },
      onPointerUp: (_) {
        if (!_allowScrolling) {
          widget.scrollController.jumpTo(_currentLockPosition);
        }
        if(widget.currentPosition < maxPinPosition){
          widget.dragEnd();
        }
      },
      child: widget.child,
    );
  }
}

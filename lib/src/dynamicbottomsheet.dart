import 'package:dynamicbottomsheet/src/helpers/drag_wrapper.dart';
import 'package:dynamicbottomsheet/src/helpers/header.dart';
import 'package:dynamicbottomsheet/src/helpers/size_notifier.dart';
import 'package:dynamicbottomsheet/src/helpers/snapping_position.dart';
import 'package:dynamicbottomsheet/src/provider/provider.dart';
import 'package:dynamicbottomsheet/src/provider/singleton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WrappedDynamicBottomSheet extends StatefulWidget {
  final Widget scaffoldBody;
  final List<Widget> children;
  // final List<String>? titles;
  final List<ScrollController?>? scrollControllers;
  final PageController? pageController;

  const WrappedDynamicBottomSheet({
    Key? key,
    required this.scaffoldBody,
    // this.titles,
    this.scrollControllers,
    this.pageController,
    required this.children,
  }) : super(key: key);

  @override
  State<WrappedDynamicBottomSheet> createState() => _WrappedDynamicBottomSheetState();
}

class _WrappedDynamicBottomSheetState extends State<WrappedDynamicBottomSheet> with TickerProviderStateMixin {
  final data = SheetData.instance;
  late TabController _tabController;
  late PageController _pageController;
  late AnimationController _animationController;
  Animation<double>? _tweenAnimation;

  bool _shouldDisposePageController = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.children.length, vsync: this);
    context.read<DynamicBottomSheetProvider>().initializeChildrenSizes(widget.children.length);

    _animationController = AnimationController(vsync: this);
    _animationController.addListener(() {
      if(_tweenAnimation == null) return;
      context.read<DynamicBottomSheetProvider>().currentPosition = _tweenAnimation!.value;
    });
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        data.onSnapCompleted?.call(
          context.read<DynamicBottomSheetProvider>().createPositionData,
          context.read<DynamicBottomSheetProvider>().lastSnappingPosition,
        );
      }
    });

    Future.delayed(const Duration(seconds: 0)).then((value) {
      final screenHeight = context.read<DynamicBottomSheetProvider>().screenHeight;
      final headerHeight = context.read<DynamicBottomSheetProvider>().headerHeight;
      final position = data.initialPosition ?? const SnappingPosition.pixels(positionPixels: 0.0);

      context.read<DynamicBottomSheetProvider>().currentPosition = position.getPositionInPixels(
        screenHeight,
        headerHeight,
      );
    });

    _pageController = widget.pageController ?? PageController();
    context.read<DynamicBottomSheetProvider>().initializeCurrentPageIndex(_pageController.initialPage.clamp(0, widget.children.length - 1));
    context.read<DynamicBottomSheetProvider>().initializePreviousPageIndex();

    _shouldDisposePageController = widget.pageController == null;
  }

  @override
  void didUpdateWidget(covariant WrappedDynamicBottomSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pageController != widget.pageController) {
      _pageController = widget.pageController ?? PageController();
      _shouldDisposePageController = widget.pageController == null;
    }
    if (oldWidget.children.length != widget.children.length) {
      context.read<DynamicBottomSheetProvider>().reinitializeSizes(length: widget.children.length,);
    }
  }

  @override
  void dispose() {
    if (_shouldDisposePageController) {
      _pageController.dispose();
    }
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('SHEET IS BUILT');
    return LayoutBuilder(
      builder: (context, boxConstraints) {
        context.read<DynamicBottomSheetProvider>().initializeSheetHeight(boxConstraints: boxConstraints);
        return Stack(
          children: [
            Positioned.fill(child: widget.scaffoldBody),
            header(),
            Positioned(
              left: 0,
              right: 0,
              top: context.read<DynamicBottomSheetProvider>().screenHeight - context.read<DynamicBottomSheetProvider>().currentPosition,
              child: ColoredBox(
                color: Colors.white,
                child: TweenAnimationBuilder<double>(
                  curve: Curves.easeInOutCubic,
                  duration: const Duration(milliseconds: 200),
                  tween: Tween<double>(begin: context.read<DynamicBottomSheetProvider>().previousSize, end: context.watch<DynamicBottomSheetProvider>().currentSize),
                  child: PageView(
                    controller: _pageController,
                    physics: const ClampingScrollPhysics(),
                    onPageChanged: (index){
                      Future.delayed(
                          const Duration(milliseconds: 30),
                          (){
                            Provider.of<DynamicBottomSheetProvider>(context, listen: false).updatePageIndex(index);
                            final canAnimate = Provider.of<DynamicBottomSheetProvider>(context, listen: false).updateMaxSnap();
                            _tabController.animateTo(index);
                            if(canAnimate){
                              final position = Provider.of<DynamicBottomSheetProvider>(context, listen: false).maxSnapPosition;
                              _snapToPosition(position, 'OnPageChanged');
                            }
                          }
                      );
                    },
                    children: _sizeReportingChildren(),
                  ),
                  builder: (context, value, child) => SizedBox(
                    height: value,
                    width: null,
                    child: child,
                  ),
                ),
              ),
            ),
          ],
        );
      }
    );
  }


  List<Widget> _sizeReportingChildren() => widget.children
      .asMap()
      .map(
        (index, child) => MapEntry(
      index,
      OverflowPage(
        dragEnd: _dragEnd,
        dragUpdate: _dragSheet,
        scrollController: widget.scrollControllers?[index],
        onSizeChange: (Size size){
          final oldHeight = Provider.of<DynamicBottomSheetProvider>(context, listen: false).updateChildSizeAt(index: index, height: size.height);

          final canAnimate = Provider.of<DynamicBottomSheetProvider>(context, listen: false).updateMaxSnap();
          if(canAnimate && oldHeight != 0.0){
            final position = Provider.of<DynamicBottomSheetProvider>(context, listen: false).maxSnapPosition;
            _snapToPosition(position, 'Child');
          }
        },
        child: child,
      ),
    ),
  )
      .values
      .toList();

  Widget header() {
    final position = context.read<DynamicBottomSheetProvider>().currentPosition;
    final dragWrapper = DragWrapper(
      dragEnd: _dragEnd,
      dragUpdate: _dragSheet,
      child: InheritedDynamicBottomSheetHeader(
        childCount: widget.children.length,
        tabController: _tabController,
        pageController: _pageController,
        child: const SheetHeader(),
      ),
    );
    return Positioned(
      left: 0,
      right: 0,
      bottom: position,
      height: context.read<DynamicBottomSheetProvider>().headerHeight,
      child: dragWrapper,
    );
  }

  TickerFuture _snapToPosition(SnappingPosition snappingPosition, String caller) {
    print('$caller called Animation');
    final position = context.read<DynamicBottomSheetProvider>().createPositionData;
    data.onSnapStart?.call(position, snappingPosition);
    context.read<DynamicBottomSheetProvider>().lastSnappingPosition = snappingPosition;
    return _animateToPosition(snappingPosition);
  }

  TickerFuture _animateToPosition(SnappingPosition snappingPosition) {
    final screenHeight = context.read<DynamicBottomSheetProvider>().screenHeight;
    final headerHeight = context.read<DynamicBottomSheetProvider>().headerHeight;
    final currentPosition = context.read<DynamicBottomSheetProvider>().currentPosition;

    _animationController.duration = snappingPosition.snappingDuration;
    var endPosition = snappingPosition.getPositionInPixels(screenHeight, headerHeight,);
    _tweenAnimation = Tween(begin: currentPosition, end: endPosition).animate(CurvedAnimation(parent: _animationController, curve: snappingPosition.snappingCurve,),);
    _animationController.reset();
    return _animationController.forward();
  }

  void _dragSheet(double dragAmount) {
    if (_animationController.isAnimating) {
      _animationController.stop();
    }
    context.read<DynamicBottomSheetProvider>().updateCurrentPosition(dragAmount);
  }

  void _dragEnd() {
    final position = context.read<DynamicBottomSheetProvider>().snappingCalculator.getBestSnappingPosition();
    _snapToPosition(position, 'DragEnd');

    // final canAnimate = Provider.of<DynamicBottomSheetProvider>(context, listen: false).updateMaxSnap();
    // if(canAnimate){
    //   final position = context.read<DynamicBottomSheetProvider>().snappingCalculator.getBestSnappingPosition();
    //   _snapToPosition(position, 'DragEnd');
    // }
  }
}

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

    _pageController.addListener(() {
      context.read<DynamicBottomSheetProvider>().updatePage(_pageController.page!.round());
    });

  }

  @override
  void didUpdateWidget(covariant WrappedDynamicBottomSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pageController != widget.pageController) {
      oldWidget.pageController?.removeListener(() {
        context.read<DynamicBottomSheetProvider>().updatePage(_pageController.page!.round());
      });
      _pageController = widget.pageController ?? PageController();
      _pageController.addListener(() {
        context.read<DynamicBottomSheetProvider>().updatePage(_pageController.page!.round());
      });
      _shouldDisposePageController = widget.pageController == null;
    }
    if (oldWidget.children.length != widget.children.length) {
      context.read<DynamicBottomSheetProvider>().reinitializeSizes(length: widget.children.length,);
    }
  }

  @override
  void dispose() {
    _pageController.removeListener(() {
      context.read<DynamicBottomSheetProvider>().updatePage(_pageController.page!.round());
    });
    if (_shouldDisposePageController) {
      _pageController.dispose();
    }
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                color: Colors.tealAccent,
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
                            final currentIndex = Provider.of<DynamicBottomSheetProvider>(context, listen: false).currentPageIndex;
                            final position = Provider.of<DynamicBottomSheetProvider>(context, listen: false).maxSnapPosition;
                            data.onPageChanged;
                            _tabController.animateTo(currentIndex);
                            _snapToPosition(position);
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

  List<Widget> _sizeReportingChildren() => widget.children
      .asMap()
      .map(
        (index, child) => MapEntry(
          index,
          OverflowPage(
            onSizeChange: (Size size){
              final children =  context.read<DynamicBottomSheetProvider>().sizes;
              print('SIZES: $children');
              final canAnimateToTop = Provider.of<DynamicBottomSheetProvider>(context, listen: false).updateChildSizeAt(index: index, height: size.height);
              print('SIZES: ${Provider.of<DynamicBottomSheetProvider>(context, listen: false).sizes} <= Height: $size <= MaxSnap: ${context.read<DynamicBottomSheetProvider>().maxSnapPosition.pixel} => CanAnimate: $canAnimateToTop');
              if(canAnimateToTop){
                /// TODO: Trigger animation

              }
            },
            child: child,
          ),
        ),
      )
      .values
      .toList();

  TickerFuture _snapToPosition(SnappingPosition snappingPosition) {
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
    // setState(() {});
    print('Drag Update $dragAmount');
  }

  void _dragEnd() {
    final position = context.read<DynamicBottomSheetProvider>().snappingCalculator.getBestSnappingPosition();
    _snapToPosition(position);
    print('Drag End ${position.pixel}');
  }
}

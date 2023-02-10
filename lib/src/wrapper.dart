import 'package:dynamicbottomsheet/src/dynamicbottomsheet.dart';
import 'package:dynamicbottomsheet/src/helpers/scroll_config.dart';
import 'package:dynamicbottomsheet/src/provider/provider.dart';
import 'package:dynamicbottomsheet/src/provider/singleton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

bool isValid(List<String>? titles, int childCount) {
  if (titles == null) {
    return true;
  }
  bool hasAtLeastOneEmptyTitle =
      titles.any((title) => title.toString().isEmpty);

  final isValid = titles.length == childCount
      ? hasAtLeastOneEmptyTitle
          ? false
          : true
      : false;
  return isValid;
}

class DynamicBottomSheet extends StatelessWidget {
  final Widget scaffoldBody;
  final List<Widget> children;
  final List<ScrollController?>? scrollControllers;
  final PageController? pageController;

  DynamicBottomSheet({
    super.key,
    required this.scaffoldBody,
    this.pageController,
    this.scrollControllers,
    required this.children,
    required double heightFactor,

    List<String>? titles,
    double? initialPosition,
    double? headerElevation,
    BorderRadiusGeometry? headerBorderRadius,
    Decoration? headerDecoration,
    Size? grabbingSize,
    Decoration? grabbingDecoration,
    EdgeInsetsGeometry? tabBarPadding,
    Color? selectedTitleColor,
    Color? unselectedTitleColor,
    TextStyle? titleStyle,
    Decoration? tabIndicatorDecoration,
    ValueChanged<int>? onPageChanged,
    Function(double pixel)? onSheetMoved,
    Function(double pixel)? onSnapCompleted,
    Function(double pixel)? onSnapStart,
  }) {
    assert(heightFactor >= 0 && heightFactor <= 1, 'Height factor must be between 0 and 1');
    assert(isValid(titles, children.length), 'In case the titles is not null, each child must have non-empty title');
    SheetData.createInstance(
        heightFactor: heightFactor,
        titles: titles,
        initialPosition: initialPosition,
        headerElevation: headerElevation,
        headerBorderRadius: headerBorderRadius,
        headerDecoration: headerDecoration,
        grabbingSize: grabbingSize,
        grabbingDecoration: grabbingDecoration,
        tabBarPadding: tabBarPadding,
        selectedTitleColor: selectedTitleColor,
        unselectedTitleColor: unselectedTitleColor,
        titleStyle: titleStyle,
        tabIndicatorDecoration: tabIndicatorDecoration,
        onPageChanged: onPageChanged,
        onSheetMoved: onSheetMoved,
        onSnapCompleted: onSnapCompleted,
        onSnapStart: onSnapStart,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DynamicBottomSheetProvider(),
      child: ScrollConfiguration(
        behavior: NoGlowBehavior(),
        child: WrappedDynamicBottomSheet(
          scaffoldBody: scaffoldBody,
          pageController: pageController,
          scrollControllers: scrollControllers,
          children: children,
        ),
      ),
    );
  }
}

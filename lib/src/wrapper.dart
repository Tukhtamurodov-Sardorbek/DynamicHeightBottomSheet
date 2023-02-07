import 'package:dynamicbottomsheet/src/dynamicbottomsheet.dart';
import 'package:dynamicbottomsheet/src/helpers/sheet_position_data.dart';
import 'package:dynamicbottomsheet/src/helpers/snapping_position.dart';
import 'package:dynamicbottomsheet/src/provider/provider.dart';
import 'package:dynamicbottomsheet/src/provider/singleton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

bool isValid(List<String>? titles, int childCount){
  if(titles == null){
    return true;
  }
  bool hasAtLeastOneEmptyTitle = titles.any((title) => title.toString().isEmpty);

  final isValid = titles.length == childCount
      ? hasAtLeastOneEmptyTitle ? false : true
      : false;
  return isValid;
}


class DynamicBottomSheet extends StatelessWidget {
  final Widget scaffoldBody;
  final List<Widget> children;
  // final List<String>? titles;
  final List<ScrollController?>? scrollControllers;
  final PageController? pageController;

  DynamicBottomSheet({
    super.key,
    required double heightFactor,
    SnappingPosition? initialPosition,
    List<String>? titles,
    required this.scaffoldBody,
    this.pageController,
    this.scrollControllers,
    required this.children,
    ValueChanged<int>? onPageChanged,
    Function(SheetPositionData positionData)? onSheetMoved,
    Function(SheetPositionData positionData, SnappingPosition snappingPosition,)? onSnapCompleted,
    Function(SheetPositionData positionData, SnappingPosition snappingPosition,)? onSnapStart,
  }) {
    assert(heightFactor >= 0 && heightFactor <= 1, 'Height factor must be between 0 and 1');
    assert(isValid(titles, children.length), 'In case the titles is not null, each child must have non-empty title');
    SheetData.createInstance(
      heightFactor: heightFactor,
      titles: titles,
      // pageController: pageController,
      initialPosition: initialPosition,
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
      child: WrappedDynamicBottomSheet(
        scaffoldBody: scaffoldBody,
        pageController: pageController,
        scrollControllers: scrollControllers,
        // titles: titles,
        children: children,
      ),
    );
  }
}

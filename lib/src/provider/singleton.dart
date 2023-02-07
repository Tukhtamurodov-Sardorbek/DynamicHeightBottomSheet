import 'package:dynamicbottomsheet/src/helpers/sheet_position_data.dart';
import 'package:dynamicbottomsheet/src/helpers/snapping_position.dart';
import 'package:flutter/material.dart';

class SheetData {
  final double _heightFactor;
  final List<String>? _titles;
  // final PageController? _pageController;
  final SnappingPosition? _initialPosition;
  final ValueChanged<int>? _onPageChanged;
  final Function(SheetPositionData positionData)? _onSheetMoved;
  final Function(SheetPositionData positionData, SnappingPosition snappingPosition,)? _onSnapCompleted;
  final Function(SheetPositionData positionData, SnappingPosition snappingPosition,)? _onSnapStart;

  final Color? _grabbingColor;
  final Color? _indicatorColor;
  final Color? _selectedTitleColor;
  final Color? _unselectedTitleColor;
  final TextStyle? _titleStyle;
  final double? _horizontalPadding;

  const SheetData._internal({
    required double heightFactor,
    List<String>? titles,
    // PageController? pageController,
    SnappingPosition? initialPosition,
    Color? grabbingColor,
    Color? indicatorColor,
    Color? selectedTitleColor,
    Color? unselectedTitleColor,
    TextStyle? titleStyle,
    double? horizontalPadding,
    ValueChanged<int>? onPageChanged,
    Function(SheetPositionData positionData)? onSheetMoved,
    Function(SheetPositionData positionData, SnappingPosition snappingPosition,)? onSnapCompleted,
    Function(SheetPositionData positionData, SnappingPosition snappingPosition,)? onSnapStart,
  })  : _heightFactor = heightFactor,
        _initialPosition = initialPosition,
        _onPageChanged = onPageChanged,
        _titles = titles,
        _grabbingColor = grabbingColor,
        _indicatorColor = indicatorColor,
        _selectedTitleColor = selectedTitleColor,
        _unselectedTitleColor = unselectedTitleColor,
        _titleStyle = titleStyle,
        _horizontalPadding = horizontalPadding,
        // _pageController = pageController,
        _onSheetMoved = onSheetMoved,
        _onSnapCompleted = onSnapCompleted,
        _onSnapStart = onSnapStart;


  double get heightFactor => _heightFactor;
  SnappingPosition? get initialPosition => _initialPosition;
  List<String>? get titles => _titles;
  Color? get grabbingColor => _grabbingColor;
  Color? get indicatorColor => _indicatorColor;
  Color? get selectedTitleColor => _selectedTitleColor;
  Color? get unselectedTitleColor => _unselectedTitleColor;
  TextStyle? get titleStyle => _titleStyle;
  double? get horizontalPadding => _horizontalPadding;
  // PageController? get pageController => _pageController;
  ValueChanged<int>? get onPageChanged => _onPageChanged;
  Function(SheetPositionData positionData)? get onSheetMoved => _onSheetMoved;
  Function(SheetPositionData positionData, SnappingPosition snappingPosition,)? get onSnapCompleted => _onSnapCompleted;
  Function(SheetPositionData positionData, SnappingPosition snappingPosition,)? get onSnapStart => _onSnapStart;


  static SheetData? _instance;
  static SheetData get instance => _instance!;
  static bool get isCreated => _instance != null;

  static void nullify(){
    _instance = null;
  }

  static void createInstance({
    required double heightFactor,
    List<String>? titles,
    // PageController? pageController,
    SnappingPosition? initialPosition,
    Color? grabbingColor,
    Color? indicatorColor,
    Color? selectedTitleColor,
    Color? unselectedTitleColor,
    TextStyle? titleStyle,
    double? horizontalPadding,
    ValueChanged<int>? onPageChanged,
    Function(SheetPositionData positionData)? onSheetMoved,
    Function(SheetPositionData positionData, SnappingPosition snappingPosition,)? onSnapCompleted,
    Function(SheetPositionData positionData, SnappingPosition snappingPosition,)? onSnapStart,
  }){
    _instance ??= SheetData._internal(
      heightFactor: heightFactor,
      titles: titles,
      // pageController: pageController,
      grabbingColor: grabbingColor,
      indicatorColor: indicatorColor,
      selectedTitleColor: selectedTitleColor,
      unselectedTitleColor: unselectedTitleColor,
      titleStyle: titleStyle,
      horizontalPadding: horizontalPadding,
      initialPosition: initialPosition,
      onPageChanged: onPageChanged,
      onSheetMoved: onSheetMoved,
      onSnapCompleted: onSnapCompleted,
      onSnapStart: onSnapStart,
    );
  }
}

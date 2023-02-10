import 'package:flutter/material.dart';

class SheetData {
  final double _heightFactor;
  final List<String>? _titles;
  final double? _initialPosition;
  final ValueChanged<int>? _onPageChanged;
  final Function(double pixel)? _onSheetMoved;
  final Function(double pixel)? _onSnapCompleted;
  final Function(double pixel)? _onSnapStart;

  final double? _headerElevation;
  final BorderRadiusGeometry? _headerBorderRadius;
  final Decoration? _headerDecoration;
  final Size? _grabbingSize;
  final Decoration? _grabbingDecoration;
  final EdgeInsetsGeometry? _tabBarPadding;
  final Color? _selectedTitleColor;
  final Color? _unselectedTitleColor;
  final TextStyle? _titleStyle;
  final Decoration? _tabIndicatorDecoration;

  const SheetData._internal({
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
  })  : _heightFactor = heightFactor,
        _initialPosition = initialPosition,
        _onPageChanged = onPageChanged,
        _titles = titles,
        _headerElevation = headerElevation,
        _headerBorderRadius = headerBorderRadius,
        _headerDecoration = headerDecoration,
        _grabbingSize = grabbingSize,
        _grabbingDecoration = grabbingDecoration,
        _tabBarPadding = tabBarPadding,
        _selectedTitleColor = selectedTitleColor,
        _unselectedTitleColor = unselectedTitleColor,
        _titleStyle = titleStyle,
        _tabIndicatorDecoration = tabIndicatorDecoration,
        _onSheetMoved = onSheetMoved,
        _onSnapCompleted = onSnapCompleted,
        _onSnapStart = onSnapStart;

  double get heightFactor => _heightFactor;
  double? get initialPosition => _initialPosition;
  List<String>? get titles => _titles;
  double? get headerElevation => _headerElevation;
  BorderRadiusGeometry? get headerBorderRadius => _headerBorderRadius;
  Decoration? get headerDecoration => _headerDecoration;
  Size? get grabbingSize => _grabbingSize;
  Decoration? get grabbingDecoration => _grabbingDecoration;
  EdgeInsetsGeometry? get tabBarPadding => _tabBarPadding;
  Color? get selectedTitleColor => _selectedTitleColor;
  Color? get unselectedTitleColor => _unselectedTitleColor;
  TextStyle? get titleStyle => _titleStyle;
  Decoration? get tabIndicatorDecoration => _tabIndicatorDecoration;
  ValueChanged<int>? get onPageChanged => _onPageChanged;
  Function(double pixel)? get onSheetMoved => _onSheetMoved;
  Function(double pixel)? get onSnapCompleted => _onSnapCompleted;
  Function(double pixel)? get onSnapStart => _onSnapStart;

  static SheetData? _instance;
  static SheetData get instance => _instance!;
  static bool get isCreated => _instance != null;
  static void nullify() {
    _instance = null;
  }

  static void createInstance({
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
    _instance ??= SheetData._internal(
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
}

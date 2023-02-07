import 'package:dynamicbottomsheet/src/helpers/sheet_position_data.dart';
import 'package:dynamicbottomsheet/src/helpers/snapping_calculator.dart';
import 'package:dynamicbottomsheet/src/helpers/snapping_position.dart';
import 'package:dynamicbottomsheet/src/provider/singleton.dart';
import 'package:flutter/cupertino.dart';

class DynamicBottomSheetProvider extends ChangeNotifier{
  late List<double> _childrenSizes;
  late double _maxSheetHeight;
  BoxConstraints? _constraints;

  final double _headerHeight = SheetData.instance.titles == null ? 45 : 75;
  int _currentPageIndex = 0;
  int _previousPageIndex = 0;

  double _currentPosition = 0.0;
  SnappingPosition _lastSnappingPosition = SheetData.instance.initialPosition ?? const SnappingPosition.pixels(positionPixels: 0.0);
  final List<SnappingPosition> _snappingPositions = [
    const SnappingPosition.pixels(positionPixels: 0.0),
    const SnappingPosition.pixels(positionPixels: 0.0),
  ];

  List<double> get sizes => _childrenSizes;

  int get currentPageIndex => _currentPageIndex;
  int get previousPageIndex => _previousPageIndex;
  double get currentSize => _childrenSizes[_currentPageIndex];
  double get previousSize => _childrenSizes[_previousPageIndex];
  double get currentPosition => _currentPosition;
  double get screenHeight => _constraints!.maxHeight;
  double get maxSheetHeight => _maxSheetHeight;
  double get headerHeight => _headerHeight;
  bool get hasTitles{
    if(SheetData.instance.titles == null){
      return false;
    }
    return true;
  }

  set currentPosition(double position) {
    if(_currentPosition != position){
      _currentPosition = position;
      notifyListeners();
      SheetData.instance.onSheetMoved?.call(createPositionData);
    }
  }
  set lastSnappingPosition(SnappingPosition position){
    if(_lastSnappingPosition != position){
      _lastSnappingPosition = position;
    }
  }


  SnappingPosition get lastSnappingPosition => _lastSnappingPosition;
  SnappingPosition get maxSnapPosition => _snappingPositions[1];
  SnappingCalculator get snappingCalculator {
    final calculator = SnappingCalculator(
      allSnappingPositions: _snappingPositions,
      lastSnappingPosition: _lastSnappingPosition,
      maxHeight: screenHeight,
      grabbingHeight: _headerHeight,
      currentPosition: _currentPosition,
    );
    return calculator;
  }
  SheetPositionData get createPositionData {
    final data = SheetPositionData(_currentPosition, snappingCalculator);
    return data;
  }

  // * Initializations
  void initializeChildrenSizes(int length){
    _childrenSizes = List.filled(length, 0.0);

  }
  void initializeSheetHeight({required BoxConstraints boxConstraints}){
    if(_constraints != boxConstraints){
      _constraints = boxConstraints;
      _maxSheetHeight = _constraints!.maxHeight * SheetData.instance.heightFactor;
    }
  }
  void initializeCurrentPageIndex(int index){
    _currentPageIndex = index;
  }
  void initializePreviousPageIndex(){
    _previousPageIndex = _currentPageIndex - 1 < 0 ? 0 : _currentPageIndex - 1;
  }


  void reinitializeSizes({required int length}) {
    final currentPageSize = _childrenSizes[_currentPageIndex];
    initializeChildrenSizes(length);

    if (_currentPageIndex >= _childrenSizes.length) {
      final differenceFromPreviousToCurrent = _previousPageIndex - _currentPageIndex;
      _currentPageIndex = _childrenSizes.length - 1;
      SheetData.instance.onPageChanged?.call(_currentPageIndex);

      _previousPageIndex = (_currentPageIndex + differenceFromPreviousToCurrent).clamp(0, _childrenSizes.length - 1);
    }

    _previousPageIndex = _previousPageIndex.clamp(0, _childrenSizes.length - 1);
    _childrenSizes[_currentPageIndex] = currentPageSize;
  }
  void updatePage(int newPageIndex) {
    if (_currentPageIndex != newPageIndex) {
      _previousPageIndex = _currentPageIndex;
      _currentPageIndex = newPageIndex;
      notifyListeners();
    }
  }
  void updateMaxSnap(){
    final height = _childrenSizes[_currentPageIndex];
    final snapPosition = SnappingPosition.pixels(positionPixels: height);
    if(_snappingPositions[1] != snapPosition){
      _snappingPositions[1] = snapPosition;
      notifyListeners();
    }
  }
  bool updateChildSizeAt({required int index, required double height}) {
    final oldHeight = _childrenSizes[index];
    if (oldHeight != height) {
      if (height >= _maxSheetHeight) {
        if (oldHeight != _maxSheetHeight) {
          _childrenSizes[index] = _maxSheetHeight;
          updateMaxSnap();

          notifyListeners();
          return oldHeight != 0.0;
        }
      } else {
        _childrenSizes[index] = height;
        updateMaxSnap();
        notifyListeners();
        return oldHeight != 0.0;
      }
    }
    return false;
  }
  double getNewPosition(double dragAmount) {
    var newPosition = _currentPosition - dragAmount;

    var calculator = snappingCalculator;
    var maxPos = calculator.getBiggestPositionPixels();
    var minPos = calculator.getSmallestPositionPixels();
    if (newPosition > maxPos) return maxPos;
    if (newPosition < minPos) return minPos;

    return newPosition;
  }
  void updateCurrentPosition(double dragAmount){
    currentPosition = getNewPosition(dragAmount);
  }

}



















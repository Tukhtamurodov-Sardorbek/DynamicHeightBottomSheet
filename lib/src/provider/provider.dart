import 'package:dynamicbottomsheet/src/provider/singleton.dart';
import 'package:flutter/cupertino.dart';

enum DragDirection {
  up,
  down,
}

class DynamicBottomSheetProvider extends ChangeNotifier{
  // * Data members
  late List<double> _childrenSizes;
  late double _maxSheetHeight;
  BoxConstraints? _constraints;
  // final double _headerHeight = SheetData.instance.titles == null ? 45 : 75;
  int _currentPageIndex = 0;
  int _previousPageIndex = 0;
  double _currentPosition = 0.0;
  double _lastPinPosition = SheetData.instance.initialPosition ?? 0.0;
  final List<double> _pinPositions = List.filled(2, 0.0);

  // * Getters & Setters
  List<double> get sizes => _childrenSizes;
  int get currentPageIndex => _currentPageIndex;
  int get previousPageIndex => _previousPageIndex;
  double get currentSize => _childrenSizes[_currentPageIndex];
  double get previousSize => _childrenSizes[_previousPageIndex];
  double get currentPosition => _currentPosition;
  double get screenHeight => _constraints!.maxHeight;
  double get maxSheetHeight => _maxSheetHeight;
  // double get headerHeight => _headerHeight;
  bool get hasTitles{
    if(SheetData.instance.titles == null){
      return false;
    }
    return true;
  }
  double get lastPinPosition => _lastPinPosition;
  double get bottomPinPosition => _pinPositions[0];
  double get topPinPosition => _pinPositions[1];
  // SnappingCalculator get snappingCalculator {
  //   final calculator = SnappingCalculator(
  //     allSnappingPositions: _snappingPositions,
  //     lastSnappingPosition: _lastSnappingPosition,
  //     maxHeight: screenHeight,
  //     grabbingHeight: _headerHeight,
  //     currentPosition: _currentPosition,
  //   );
  //   return calculator;
  // }
  // SheetPositionData get createPositionData {
  //   final data = SheetPositionData(_currentPosition, snappingCalculator);
  //   return data;
  // }

  set currentPosition(double position) {
    if(_currentPosition != position){
      _currentPosition = position;
      notifyListeners();
      SheetData.instance.onSheetMoved?.call(_currentPosition);
    }
  }
  set lastPinPosition(double position){
    if(_lastPinPosition != position){
      _lastPinPosition = position;
    }
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

  // * Member Functions
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
  void updatePageIndex(int newPageIndex) {
    if (_currentPageIndex != newPageIndex) {
      _previousPageIndex = _currentPageIndex;
      _currentPageIndex = newPageIndex;
      notifyListeners();
    }
  }
  bool updateMaxSnap(){
    final height = _childrenSizes[_currentPageIndex];
    final canUpdate = _pinPositions[1] != height;

    if(canUpdate){
      _pinPositions[1] = height;
      notifyListeners();
    }

    return canUpdate;
  }
  double updateChildSizeAt({required int index, required double height}) {
    final oldHeight = _childrenSizes[index];

    if (oldHeight != height) {
      if (height >= _maxSheetHeight) {
        if (oldHeight != _maxSheetHeight) {
          _childrenSizes[index] = _maxSheetHeight;
          notifyListeners();
        }
      } else {
        _childrenSizes[index] = height;
        notifyListeners();
      }
    }
    return oldHeight;
  }
  double getNewPosition(double dragAmount) {
    var newPosition = _currentPosition - dragAmount;

    if (newPosition > topPinPosition) return topPinPosition;
    if (newPosition < bottomPinPosition) return bottomPinPosition;

    return newPosition;
  }
  void updateCurrentPosition(double dragAmount){
    currentPosition = getNewPosition(dragAmount);
  }


  double get bestPinPosition{
    _pinPositions.sort();
    if(_currentPosition >= _pinPositions[1]){
      return _pinPositions[1];
    }
    if(_currentPosition <= _pinPositions[0]){
      return _pinPositions[0];
    }
    var relevantPinPositions = _getRelevantPinPositions();
    return _getClosestPinPosition(relevantPinPositions);
  }

  List<double> _getRelevantPinPositions(){
    final dragDirection = _getDragDirection();
    final result = _pinPositions.where((position){
      if(position == _lastPinPosition) return true;
      if(position == _currentPosition) return true;
      if(position > _currentPosition && dragDirection == DragDirection.down) return false;
      if(position < _currentPosition && dragDirection == DragDirection.up) return false;
      return true;
    }).toList();
    return result;
  }
  DragDirection _getDragDirection(){
    if(_currentPosition > _lastPinPosition){
      return DragDirection.up;
    } else{
      return DragDirection.down;
    }
  }
  double _getClosestPinPosition(List<double> relevantPinPositions){
    double? minDistance;
    double? closestPinPosition;
    for(var position in relevantPinPositions){
      double sensitivityFactor = position == _lastPinPosition ? 5 : 1;
      final distanceToPin = (position - _currentPosition).abs();
      double distance = distanceToPin * sensitivityFactor;
      if(minDistance == null || distance < minDistance){
        minDistance = distance;
        closestPinPosition = position;
      }
    }
    return closestPinPosition!;
  }
}
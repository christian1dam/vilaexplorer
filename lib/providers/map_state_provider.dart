import 'package:flutter/material.dart';

class MapStateProvider extends ChangeNotifier {
  bool _isMapLoaded = false;

  bool get isMapLoaded => _isMapLoaded;

  set setMapLoaded(bool isItLoaded) {
    _isMapLoaded = isItLoaded;
    notifyListeners();
  }
}
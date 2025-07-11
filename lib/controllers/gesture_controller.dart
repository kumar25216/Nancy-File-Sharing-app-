import 'package:flutter/material.dart';

class GestureController extends ChangeNotifier {
  bool _fistClosed = false;
  bool _fistOpened = false;

  bool get isFistClosed => _fistClosed;
  bool get isFistOpened => _fistOpened;

  void detectFistClosed() {
    _fistClosed = true;
    _fistOpened = false;
    notifyListeners();
  }

  void detectFistOpened() {
    _fistOpened = true;
    _fistClosed = false;
    notifyListeners();
  }

  void reset() {
    _fistClosed = false;
    _fistOpened = false;
    notifyListeners();
  }
}

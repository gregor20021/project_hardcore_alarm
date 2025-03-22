
import 'package:flutter/cupertino.dart';

class InputErrorController extends ChangeNotifier {
  String? _error;

  InputErrorController({String? error}) : _error = error;

  setError(String error) {
    this._error = error;
    notifyListeners();
  }

  clearError() {
    this._error = null;
    notifyListeners();
  }

  String? get error => _error;
}
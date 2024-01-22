import 'package:flutter/material.dart';

class NotifyListener extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void onChange() {
    notifyListeners();
  }
}

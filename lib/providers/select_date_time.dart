import 'package:flutter/material.dart';

class SelectDateTime extends ChangeNotifier {
  DateTime _selectedDateTime = DateTime.now();
  DateTime get selectedDateTime => _selectedDateTime;

  void updateDateTime(DateTime newDateTime) {
    _selectedDateTime = newDateTime;
    notifyListeners();
  }
}

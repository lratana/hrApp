import 'package:flutter/material.dart';

ThemeData? themeLight() {
  return ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}

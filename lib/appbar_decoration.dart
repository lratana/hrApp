import 'package:flutter/material.dart';

Decoration? decoration({Color? gradientStart, Color? gradientEnd}) {
  const Color defaultGradientStart = Color(0xFF2E7D95);
  const Color defaultGradientEnd = Color(0xFF3A9BB5);
  return BoxDecoration(
    gradient: LinearGradient(
      colors: [
        gradientStart ?? defaultGradientStart,
        gradientEnd ?? defaultGradientEnd,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );
}

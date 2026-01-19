import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData darkTheme(int scaleIndex) {
  final fgColor = Colors.white;
  final bgColor = Colors.orange;
  final bg2Color = Colors.indigo;
  return ThemeData(
    brightness: Brightness.dark,
    textTheme: TextTheme(
      titleSmall: GoogleFonts.notoSans(fontSize: 16 + (scaleIndex * 3)),
      titleMedium: GoogleFonts.notoSans(fontSize: 20 + (scaleIndex * 3)),
      titleLarge: GoogleFonts.notoSans(fontSize: 24 + (scaleIndex * 3)),
      bodyMedium: GoogleFonts.notoSans(fontSize: 18 + (scaleIndex * 3)),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: bgColor,
      foregroundColor: fgColor,
      centerTitle: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: bgColor,
      selectedItemColor: fgColor,
    ),
  );
}

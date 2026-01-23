import 'package:flutter/material.dart';
import 'package:flutter_application_1/dark_theme.dart';
import 'package:flutter_application_1/providers/select_date_time.dart';
import 'package:flutter_application_1/providers/textsize_logic.dart';
import 'package:flutter_application_1/providers/theme_logic.dart';
import 'package:flutter_application_1/screens/slash_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeLogic()),
        ChangeNotifierProvider(create: (_) => TextsizeLogic()),
        ChangeNotifierProvider(create: (_) => SelectDateTime()),
      ],
      child: const HRPortalApp(),
    ),
  );
}

class HRPortalApp extends StatefulWidget {
  const HRPortalApp({super.key});

  @override
  State<HRPortalApp> createState() => _HRPortalAppState();
}

class _HRPortalAppState extends State<HRPortalApp> {
  @override
  Widget build(BuildContext context) {
    return Consumer2(
      builder:
          (context, ThemeLogic themeLogic, TextsizeLogic textSizeLogic, child) {
            return MaterialApp(
              title: 'HR Portal',
              debugShowCheckedModeBanner: false,
              theme: darkTheme(textSizeLogic.scaleIndex),
              darkTheme: darkTheme(textSizeLogic.scaleIndex),
              themeMode: themeLogic.themeIndex == 1
                  ? ThemeMode.dark
                  : themeLogic.themeIndex == 2
                  ? ThemeMode.light
                  : ThemeMode.system,
              home: const SplashScreen(),
            );
          },
    );
  }
}

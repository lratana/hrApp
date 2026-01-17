import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/select_date_time.dart';
import 'package:flutter_application_1/providers/theme_logic.dart';
import 'package:flutter_application_1/screens/slash_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeLogic()),
        ChangeNotifierProvider(create: (_) => SelectDateTime()),
      ],
      child: const HRPortalApp(),
    ),
  );
}

class HRPortalApp extends StatelessWidget {
  const HRPortalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HR Portal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

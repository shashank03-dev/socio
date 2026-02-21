import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/main/screens/main_screen.dart';

void main() {
  runApp(const SocioApp());
}

class SocioApp extends StatelessWidget {
  const SocioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Socio',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const MainScreen(),
    );
  }
}

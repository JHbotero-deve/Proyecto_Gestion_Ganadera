import 'package:flutter/material.dart';
import 'core/theme/gavac_theme.dart';

void main() {
  runApp(const GAVACApp());
}

class GAVACApp extends StatelessWidget {
  const GAVACApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GAVAC - Gestión Ganadera',
      debugShowCheckedModeBanner: false,
      theme: GavacTheme.lightTheme, // Aquí aplicamos tu tema
      home: const Scaffold(
        body: Center(
          child: Text(
            'Design System GAVAC Activo',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

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
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1A3A32)),
      ),
      home: const Scaffold(
        body: Center(child: Text('Base GAVAC Lista')),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SanidadScreen extends StatefulWidget {
  const SanidadScreen({super.key});

  @override
  State<SanidadScreen> createState() => _SanidadScreenState();
}

class _SanidadScreenState extends State<SanidadScreen> {
  static const Color primaryColor = Color(0xFF1A3A32);
  static const Color backgroundColor = Color(0xFFF7F9F7);
  static const Color textMuted = Color(0xFF94A3B8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Control y Sanidad Ganadera',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Center(
                  child: Text(
                    'No hay registros sanitarios disponibles',
                    style: GoogleFonts.plusJakartaSans(fontSize: 16, color: textMuted),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

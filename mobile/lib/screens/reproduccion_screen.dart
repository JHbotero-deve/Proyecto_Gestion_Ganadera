import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReproduccionScreen extends StatefulWidget {
  const ReproduccionScreen({super.key});

  @override
  State<ReproduccionScreen> createState() => _ReproduccionScreenState();
}

class _ReproduccionScreenState extends State<ReproduccionScreen> {
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
                'Control de Eventos Reproductivos',
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
                    'No hay eventos reproductivos registrados',
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

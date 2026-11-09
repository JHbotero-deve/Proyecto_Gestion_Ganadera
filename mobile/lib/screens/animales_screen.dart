import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnimalRecord {
  final String id;
  final String chapeta;
  final String especie;
  final String raza;
  final String sexo;
  final String edad;
  final String peso;
  final String estadoSincronizacion;

  const AnimalRecord({
    required this.id,
    required this.chapeta,
    required this.especie,
    required this.raza,
    required this.sexo,
    required this.edad,
    required this.peso,
    required this.estadoSincronizacion,
  });
}

class AnimalesScreen extends StatefulWidget {
  final String totalAnimales;
  final String sincronizadosCount;
  final String pendientesCount;
  final List<AnimalRecord> animales;
  final Function(Map<String, String>)? onGuardarAnimal;

  const AnimalesScreen({
    super.key,
    this.totalAnimales = '0',
    this.sincronizadosCount = '0',
    this.pendientesCount = '0',
    this.animales = const [],
    this.onGuardarAnimal,
  });

  @override
  State<AnimalesScreen> createState() => _AnimalesScreenState();
}

class _AnimalesScreenState extends State<AnimalesScreen> {
  static const Color primaryColor = Color(0xFF1A3A32);
  static const Color accentColor = Color(0xFF2E5A4D);
  static const Color backgroundColor = Color(0xFFF7F9F7);
  static const Color cardColor = Colors.white;
  static const Color borderColor = Color(0xFFF1F5F9);
  static const Color textMuted = Color(0xFF94A3B8);

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_handleSearchChanged);
  }

  void _handleSearchChanged() {
    if (!mounted) return;
    setState(() {
      _searchQuery = _searchController.text.trim().toLowerCase();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<AnimalRecord> get _filteredAnimales {
    if (_searchQuery.isEmpty) return widget.animales;
    return widget.animales
        .where((animal) => animal.chapeta.toLowerCase().contains(_searchQuery))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Gestión de Animales',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: primaryColor,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white),
                    icon: const Icon(Icons.add),
                    label: const Text('Registrar Animal'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: _filteredAnimales.isEmpty
                    ? Center(
                        child: Text(
                          'No hay animales registrados',
                          style: GoogleFonts.plusJakartaSans(fontSize: 16, color: textMuted),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _filteredAnimales.length,
                        itemBuilder: (context, index) {
                          final animal = _filteredAnimales[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              title: Text(animal.chapeta, style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text('${animal.especie} • ${animal.raza}'),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

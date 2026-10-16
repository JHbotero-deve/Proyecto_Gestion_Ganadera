import 'package:flutter/material.dart';
import '../../../../core/theme/gavac_colors.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  static const modules = [
    ('Fincas', Icons.landscape_outlined, 'Predios y ubicación'),
    ('Animales', Icons.pets_outlined, 'Identificación y datos'),
    ('Sanidad', Icons.medical_services_outlined, 'Vacunas y tratamientos'),
    ('Reproducción', Icons.favorite_outline, 'Eventos reproductivos'),
    ('Historial', Icons.history, 'Trazabilidad animal'),
    ('Sincronización', Icons.sync, 'Estado de conexión'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GavacColors.background,
      appBar: AppBar(
        backgroundColor: GavacColors.primary,
        foregroundColor: Colors.white,
        title: const Text(
          'GAVAC - Dashboard',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Card(
            color: GavacColors.surface,
            child:  Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Panel de gestión',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: GavacColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Administra la información ganadera desde una aplicación organizada y trazable.',
                    style: TextStyle(
                      fontSize: 14,
                      color: GavacColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: modules.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.08,
            ),
            itemBuilder: (context, i) {
              final item = modules[i];
              return Card(
                color: GavacColors.surface,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${item.$1}: interfaz en construcción')),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(item.$2, size: 30, color: GavacColors.primary),
                        const SizedBox(height: 10),
                        Text(
                          item.$1,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: GavacColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.$3,
                          style: const TextStyle(
                            fontSize: 12,
                            color: GavacColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
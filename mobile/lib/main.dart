import 'package:flutter/material.dart';

void main() => runApp(const GestionGanaderaApp());

class GestionGanaderaApp extends StatelessWidget {
  const GestionGanaderaApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Gestión Ganadera',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF386641),
          ),
          useMaterial3: true,
        ),
        home: const DashboardPage(),
      );
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  static const modules = [
    ('Fincas', Icons.landscape_outlined, 'Predios y ubicación'),
    ('Animales', Icons.pets_outlined, 'Identificación y datos'),
    ('Sanidad', Icons.medical_services_outlined, 'Vacunas y tratamientos'),
    ('Reproducción', Icons.favorite_outline, 'Eventos reproductivos'),
    ('Historial', Icons.history, 'Trazabilidad animal'),
    ('Sincronización', Icons.sync, 'Estado de conexión'),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Gestión Ganadera')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Panel de gestión',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Administra la información ganadera desde una aplicación organizada y trazable.',
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
                          Icon(item.$2, size: 30),
                          const SizedBox(height: 10),
                          Text(
                            item.$1,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(item.$3),
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

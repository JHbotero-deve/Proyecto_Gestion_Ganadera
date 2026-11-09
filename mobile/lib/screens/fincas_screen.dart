import 'package:flutter/material.dart';
import '../config/gavac_colors.dart';
import '../models/finca_model.dart';

class FincasScreen extends StatefulWidget {
  const FincasScreen({super.key});

  @override
  State<FincasScreen> createState() => _FincasScreenState();
}

class _FincasScreenState extends State<FincasScreen> {
  // Lista inicial vacía (sin datos de prueba pesados)
  final List<FincaModel> _fincas = [];

  void _showFincaDialog() {
    final nombreController = TextEditingController();
    final ubicacionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nueva Finca'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(labelText: 'Nombre de la Finca', hintText: 'Ej. Hato San José'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: ubicacionController,
              decoration: const InputDecoration(labelText: 'Ubicación', hintText: 'Ej. Meta, Colombia'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: GavacColors.primary, foregroundColor: Colors.white),
            onPressed: () {
              if (nombreController.text.trim().isNotEmpty) {
                setState(() {
                  _fincas.add(
                    FincaModel(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      nombre: nombreController.text.trim(),
                      ubicacion: ubicacionController.text.trim(),
                      activa: true,
                    ),
                  );
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Finca agregada con éxito')),
                );
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Fincas'),
        backgroundColor: GavacColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Listado de Fincas', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: GavacColors.primary)),
                ElevatedButton.icon(
                  onPressed: _showFincaDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('Nueva Finca'),
                  style: ElevatedButton.styleFrom(backgroundColor: GavacColors.primary, foregroundColor: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _fincas.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.landscape_outlined, size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text('No hay fincas registradas', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _fincas.length,
                      itemBuilder: (context, index) {
                        final finca = _fincas[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: const CircleAvatar(backgroundColor: Color(0xFFE2E8F0), child: Icon(Icons.landscape, color: GavacColors.primary)),
                            title: Text(finca.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(finca.ubicacion.isNotEmpty ? finca.ubicacion : 'Sin ubicación'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.red),
                              onPressed: () => setState(() => _fincas.removeAt(index)),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../config/gavac_colors.dart';

class ValidacionScreen extends StatefulWidget {
  const ValidacionScreen({super.key});

  @override
  State<ValidacionScreen> createState() => _ValidacionScreenState();
}

class _ValidacionScreenState extends State<ValidacionScreen> {
  // Lista inicial vacía
  final List<Map<String, dynamic>> _registrosPendientes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Validación de Registros'),
        backgroundColor: GavacColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Registros Pendientes de Validación',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: GavacColors.primary),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: _registrosPendientes.isEmpty
                  ? Center(
                      child: Text(
                        'No hay registros pendientes de validación',
                        style: TextStyle(color: Colors.grey[500], fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _registrosPendientes.length,
                      itemBuilder: (context, index) {
                        final reg = _registrosPendientes[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            title: Text('${reg['tipo']} - ${reg['detalle']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text('Trabajador: ${reg['trabajador']}'),
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

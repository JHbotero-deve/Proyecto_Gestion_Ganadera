import 'package:flutter/material.dart';
import '../config/gavac_colors.dart';
import '../models/usuario_model.dart';

class UsuariosScreen extends StatefulWidget {
  const UsuariosScreen({super.key});

  @override
  State<UsuariosScreen> createState() => _UsuariosScreenState();
}

class _UsuariosScreenState extends State<UsuariosScreen> {
  // Lista inicial vacía (sin datos de prueba pesados)
  final List<UsuarioModel> _usuarios = [];

  void _showUsuarioDialog() {
    final nombreController = TextEditingController();
    final correoController = TextEditingController();
    String rolSeleccionado = 'Veterinario';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Registrar Usuario y Rol'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nombreController,
                decoration: const InputDecoration(labelText: 'Nombre completo', hintText: 'Ej. Juan Pérez'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: correoController,
                decoration: const InputDecoration(labelText: 'Correo electrónico', hintText: 'juan@gavac.pro'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: rolSeleccionado,
                decoration: const InputDecoration(labelText: 'Rol'),
                items: ['Administrador', 'Veterinario', 'Trabajador de campo']
                    .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                    .toList(),
                onChanged: (val) => setDialogState(() => rolSeleccionado = val!),
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
                if (correoController.text.trim().isNotEmpty) {
                  setState(() {
                    _usuarios.add(
                      UsuarioModel(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        nombre: nombreController.text.trim(),
                        correo: correoController.text.trim(),
                        rol: rolSeleccionado,
                        fincaId: '1',
                        activo: true,
                      ),
                    );
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Usuario registrado con éxito')),
                  );
                }
              },
              child: const Text('Registrar'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Usuarios y Roles'),
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
                const Text('Usuarios del Sistema', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: GavacColors.primary)),
                ElevatedButton.icon(
                  onPressed: _showUsuarioDialog,
                  icon: const Icon(Icons.person_add),
                  label: const Text('Nuevo Usuario'),
                  style: ElevatedButton.styleFrom(backgroundColor: GavacColors.primary, foregroundColor: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _usuarios.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text('No hay usuarios registrados', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _usuarios.length,
                      itemBuilder: (context, index) {
                        final user = _usuarios[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: CircleAvatar(backgroundColor: Colors.blue[100], child: Text(user.nombre.isNotEmpty ? user.nombre[0].toUpperCase() : 'U')),
                            title: Text(user.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text('${user.correo} • Rol: ${user.rol}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.red),
                              onPressed: () => setState(() => _usuarios.removeAt(index)),
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

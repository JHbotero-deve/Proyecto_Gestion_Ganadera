import 'package:flutter/material.dart';
import '../config/gavac_colors.dart';

class AdministracionScreen extends StatefulWidget {
  const AdministracionScreen({super.key});

  @override
  State<AdministracionScreen> createState() => _AdministracionScreenState();
}

class _AdministracionScreenState extends State<AdministracionScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, String>> _fincas = [];
  final List<Map<String, String>> _usuarios = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
                  _fincas.add({
                    'nombre': nombreController.text.trim(),
                    'ubicacion': ubicacionController.text.trim(),
                  });
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
                    _usuarios.add({
                      'nombre': nombreController.text.trim(),
                      'correo': correoController.text.trim(),
                      'rol': rolSeleccionado,
                    });
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
        title: const Text('Módulo de Administración'),
        backgroundColor: GavacColors.primary,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(icon: Icon(Icons.landscape), text: 'Fincas'),
            Tab(icon: Icon(Icons.people), text: 'Usuarios y Roles'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // TAB 1: FINCAS
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Gestión de Fincas', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: GavacColors.primary)),
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
                                title: Text(finca['nombre'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text(finca['ubicacion'] ?? 'Sin ubicación'),
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

          // TAB 2: USUARIOS Y ROLES
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Gestión de Usuarios y Roles', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: GavacColors.primary)),
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
                                leading: CircleAvatar(backgroundColor: Colors.blue[100], child: Text(user['nombre'] != null && user['nombre']!.isNotEmpty ? user['nombre']![0].toUpperCase() : 'U')),
                                title: Text(user['nombre'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text('${user['correo']} • Rol: ${user['rol']}'),
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
        ],
      ),
    );
  }
}

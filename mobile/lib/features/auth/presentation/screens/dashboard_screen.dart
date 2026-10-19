import 'package:flutter/material.dart';
import '../../../../core/theme/gavac_colors.dart';
import '../../../../core/utils/app_session.dart';
import '../../../admin/presentation/screens/gestion_fincas_screen.dart';
import '../../../admin/presentation/screens/gestion_usuarios_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _menuItems = [
    {'icon': Icons.dashboard_outlined, 'label': 'Inicio'},
    {'icon': Icons.pets_outlined, 'label': 'Animales'},
    {'icon': Icons.shield_outlined, 'label': 'Sanidad'},
    {'icon': Icons.favorite_border, 'label': 'Reproducción'},
    {'icon': Icons.water_drop_outlined, 'label': 'Producción'},
    {'icon': Icons.inventory_2_outlined, 'label': 'Inventario'},
    {'icon': Icons.bar_chart_outlined, 'label': 'Reportes'},
    {'icon': Icons.admin_panel_settings_outlined, 'label': 'Admin'},
  ];

  // Función para cerrar sesión
  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar Sesión'),
        content: const Text('¿Estás seguro que deseas salir?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Cierra el diálogo
              AppSession.clear(); // Limpia la sesión
              Navigator.pushReplacementNamed(context, '/login'); // Va al login
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Salir'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Row(
        children: [
          // SIDEBAR
          Container(
            width: 260,
            color: GavacColors.primary,
            child: Column(
              children: [
                const SizedBox(height: 30),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    children: [
                      Text(
                        'GAVAC',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                // Menú principal
                Expanded(
                  child: ListView.builder(
                    itemCount: _menuItems.length,
                    itemBuilder: (context, index) {
                      final isSelected = index == _selectedIndex;
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        child: Material(
                          color: isSelected ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              setState(() => _selectedIndex = index);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              child: Row(
                                children: [
                                  Icon(
                                    _menuItems[index]['icon'] as IconData,
                                    color: isSelected
                                        ? GavacColors.primary
                                        : Colors.white70,
                                    size: 22,
                                  ),
                                  const SizedBox(width: 16),
                                  Text(
                                    _menuItems[index]['label'] as String,
                                    style: TextStyle(
                                      color: isSelected
                                          ? GavacColors.primary
                                          : Colors.white70,
                                      fontWeight: isSelected
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Separador
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Divider(color: Colors.white24, thickness: 1),
                ),
                const SizedBox(height: 12),

                // Botón de Salir
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: _handleLogout,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.logout,
                              color: Colors.redAccent,
                              size: 22,
                            ),
                            const SizedBox(width: 16),
                            const Text(
                              'Salir',
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),

          // CONTENIDO PRINCIPAL
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Superior Común
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _selectedIndex == 7 ? 'Administración' : _menuItems[_selectedIndex]['label'],
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: GavacColors.primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _selectedIndex == 7
                                ? 'Gestión centralizada de fincas, usuarios y validaciones'
                                : 'Resumen general de tu finca',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          // Selector de Finca
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              border:
                                  Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.location_on_outlined,
                                    color: GavacColors.primary, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  AppSession.farmName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: GavacColors.textPrimary),
                                ),
                                const SizedBox(width: 8),
                                Icon(Icons.keyboard_arrow_down,
                                    color: Colors.grey[600]),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Campana Notificaciones
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: Icon(Icons.notifications_outlined,
                                color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Contenido Dinámico según la Opción del Menú
                  _buildMainContent(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon,
      Color iconColor, Color iconBg) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                Icon(Icons.more_horiz, color: Colors.grey[400]),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.grey[600],
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: GavacColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Contenido dinámico según el índice seleccionado en el sidebar
  Widget _buildMainContent() {
    if (_selectedIndex == 7) {
      return _buildAdminHub();
    }
    return _buildHomeContent();
  }

  // Vista de Inicio (Home) con Banner y KPIs
  Widget _buildHomeContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Banner de Bienvenida
        Container(
          width: double.infinity,
          height: 220,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            image: const DecorationImage(
              image: NetworkImage(
                  'https://images.unsplash.com/photo-1500382017468-9049fed747ef?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  GavacColors.primary.withOpacity(0.95),
                  GavacColors.primary.withOpacity(0.6),
                  Colors.transparent,
                ],
              ),
            ),
            padding: const EdgeInsets.all(40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Bienvenido, ${AppSession.userName}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Este es el estado actual de tu\nactivo ganadero hoy.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),

        // Tarjetas de Estadísticas (KPIs)
        Row(
          children: [
            _buildStatCard('TOTAL ANIMALES', '0', Icons.grid_view,
                const Color(0xFF64748B), const Color(0xFFF1F5F9)),
            const SizedBox(width: 24),
            _buildStatCard('EN SANIDAD', '0', Icons.shield_outlined,
                const Color(0xFF10B981), const Color(0xFFD1FAE5)),
            const SizedBox(width: 24),
            _buildStatCard('REPRODUCCIÓN', '0', Icons.favorite_border,
                const Color(0xFFEF4444), const Color(0xFFFEE2E2)),
            const SizedBox(width: 24),
            _buildStatCard(
                'ALERTAS',
                '0',
                Icons.warning_amber_rounded,
                const Color(0xFFF59E0B),
                const Color(0xFFFEF3C7)),
          ],
        ),
      ],
    );
  }

  // Panel central de Administración rediseñado basado en el Mockup
  Widget _buildAdminHub() {
    final List<Map<String, dynamic>> fincasRegistradas = [];
    final List<Map<String, dynamic>> usuariosRegistrados = [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // BOTONES DE ACCIÓN SUPERIOR
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GestionFincasAdminScreen()),
                );
              },
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Nueva Finca'),
              style: OutlinedButton.styleFrom(
                foregroundColor: GavacColors.primary,
                side: const BorderSide(color: GavacColors.primary, width: 1.5),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                textStyle: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GestionUsuariosAdminScreen()),
                );
              },
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Nuevo Usuario'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D9488),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                textStyle: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GestionUsuariosAdminScreen()),
                );
              },
              icon: const Icon(Icons.person_add_alt_1, size: 18),
              label: const Text('Asignar Personal'),
              style: ElevatedButton.styleFrom(
                backgroundColor: GavacColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                textStyle: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),

        // SECCIONES A DOS COLUMNAS
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // COLUMNA 1: Fincas Registradas
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Fincas Registradas',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: GavacColors.primary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: const [
                        Expanded(flex: 2, child: Text('NOMBRE', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF94A3B8)))),
                        Expanded(flex: 2, child: Text('UBICACIÓN', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF94A3B8)))),
                        Expanded(flex: 1, child: Text('ACCIÓN', textAlign: TextAlign.right, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF94A3B8)))),
                      ],
                    ),
                    const Divider(height: 24),
                    fincasRegistradas.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: Center(
                              child: Text(
                                'No hay fincas registradas',
                                style: TextStyle(color: Colors.grey[500], fontSize: 14),
                              ),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: fincasRegistradas.length,
                            itemBuilder: (context, index) {
                              final finca = fincasRegistradas[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                child: Row(
                                  children: [
                                    Expanded(flex: 2, child: Text(finca['nombre'], style: const TextStyle(fontWeight: FontWeight.w600, color: GavacColors.textPrimary))),
                                    Expanded(flex: 2, child: Text(finca['ubicacion'], style: const TextStyle(color: GavacColors.textSecondary))),
                                    Expanded(
                                      flex: 1,
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: TextButton(
                                          onPressed: () {},
                                          child: const Text('GESTIONAR', style: TextStyle(fontWeight: FontWeight.w700, color: GavacColors.primary, fontSize: 13)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 24),

            // COLUMNA 2: Gestión de Usuarios y Permisos
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Gestión de Usuarios y Permisos',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: GavacColors.primary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: const [
                        Expanded(flex: 2, child: Text('EMAIL / ROL', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF94A3B8)))),
                        Expanded(flex: 2, child: Text('PERMISOS MÓDULOS (BLOQUEO)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF94A3B8)))),
                        Expanded(flex: 1, child: Text('ACCIÓN', textAlign: TextAlign.right, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF94A3B8)))),
                      ],
                    ),
                    const Divider(height: 24),
                    usuariosRegistrados.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: Center(
                              child: Text(
                                'No hay usuarios registrados',
                                style: TextStyle(color: Colors.grey[500], fontSize: 14),
                              ),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: usuariosRegistrados.length,
                            itemBuilder: (context, index) {
                              final user = usuariosRegistrados[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                child: Row(
                                  children: [
                                    Expanded(flex: 2, child: Text(user['email'], style: const TextStyle(fontWeight: FontWeight.w600, color: GavacColors.textPrimary))),
                                    Expanded(flex: 2, child: Text(user['permisos'], style: const TextStyle(color: GavacColors.textSecondary))),
                                    Expanded(
                                      flex: 1,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.edit_outlined, size: 18, color: Colors.grey),
                                            onPressed: () {},
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete_outline, size: 18, color: Colors.redAccent),
                                            onPressed: () {},
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Modelo de datos para la HU-006 (Registro de Animales)
class AnimalRecord {
  final String id;
  final String chapeta;
  final String especie;
  final String raza;
  final String sexo;
  final String edad;
  final String peso;
  final String estadoSincronizacion; // 'Sincronizado' o 'Pendiente Local'

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
    Key? key,
    this.totalAnimales = '0',
    this.sincronizadosCount = '0',
    this.pendientesCount = '0',
    this.animales = const [],
    this.onGuardarAnimal,
  }) : super(key: key);

  @override
  State<AnimalesScreen> createState() => _AnimalesScreenState();
}

class _AnimalesScreenState extends State<AnimalesScreen> {
  // Colores Oficiales GAVAC Design System
  static const Color primaryColor = Color(0xFF1A3A32); // Deep Forest Green
  static const Color accentColor = Color(0xFF2E5A4D);  // Dark Emerald Accent
  static const Color backgroundColor = Color(0xFFF7F9F7); // Soft Clean Off-White
  static const Color cardColor = Color(0xFFFFFFFF);
  static const Color borderColor = Color(0xFFF1F5F9);
  static const Color textMuted = Color(0xFF94A3B8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 28),
              _buildKpiMetricsRow(),
              const SizedBox(height: 32),
              _buildDataTableSection(context),
            ],
          ),
        ),
      ),
    );
  }

  // Encabezado del Módulo con Botón de Registro HU-006
  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'HU-006: Registro de Animales',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Control individual de ganado mediante chapeta única y sincronización offline/online.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: textMuted,
              ),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () => _mostrarModalRegistrarAnimal(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 2,
          ),
          icon: const Icon(Icons.add_circle_outline_rounded, size: 20),
          label: Text(
            'Registrar Animal',
            style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }

  // Tarjetas de Métricas KPI
  Widget _buildKpiMetricsRow() {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWide = constraints.maxWidth > 900;
        return Flex(
          direction: isWide ? Axis.horizontal : Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildKpiCard(
              title: 'Total Animales',
              value: widget.totalAnimales,
              subtitle: 'Inventario general activo',
              icon: Icons.pets_rounded,
              iconBgColor: const Color(0xFFEFF6FF),
              iconColor: const Color(0xFF2563EB),
            ),
            SizedBox(height: isWide ? 0 : 16, width: isWide ? 16 : 0),
            _buildKpiCard(
              title: 'Sincronizados',
              value: widget.sincronizadosCount,
              subtitle: 'Actualizados en servidor',
              icon: Icons.cloud_done_rounded,
              iconBgColor: const Color(0xFFECFDF5),
              iconColor: const Color(0xFF059669),
            ),
            SizedBox(height: isWide ? 0 : 16, width: isWide ? 16 : 0),
            _buildKpiCard(
              title: 'Pendientes Local',
              value: widget.pendientesCount,
              subtitle: 'A la espera de conexión',
              icon: Icons.cloud_off_rounded,
              iconBgColor: const Color(0xFFFFFBEB),
              iconColor: const Color(0xFFD97706),
            ),
          ],
        );
      },
    );
  }

  Widget _buildKpiCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
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
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: textMuted,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 40,
                fontWeight: FontWeight.w900,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Tabla de Datos de Animales
  Widget _buildDataTableSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(36),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
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
              Text(
                'Listado de Ganado Registrado',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: primaryColor,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.filter_list_rounded, color: primaryColor),
                tooltip: 'Filtrar animales',
              ),
            ],
          ),
          const SizedBox(height: 16),
          widget.animales.isEmpty
              ? _buildEmptyState()
              : SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(backgroundColor),
              dataRowMinHeight: 64,
              dataRowMaxHeight: 64,
              columns: [
                DataColumn(label: _buildTableHeader('CHAPETA ÚNICA')),
                DataColumn(label: _buildTableHeader('ESPECIE')),
                DataColumn(label: _buildTableHeader('RAZA')),
                DataColumn(label: _buildTableHeader('SEXO')),
                DataColumn(label: _buildTableHeader('EDAD')),
                DataColumn(label: _buildTableHeader('PESO')),
                DataColumn(label: _buildTableHeader('ESTADO SINCRONIZACIÓN')),
              ],
              rows: widget.animales.map((animal) {
                return DataRow(
                  cells: [
                    DataCell(
                      Text(
                        animal.chapeta,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: primaryColor,
                        ),
                      ),
                    ),
                    DataCell(Text(animal.especie, style: GoogleFonts.plusJakartaSans(fontSize: 14))),
                    DataCell(Text(animal.raza, style: GoogleFonts.plusJakartaSans(fontSize: 14))),
                    DataCell(Text(animal.sexo, style: GoogleFonts.plusJakartaSans(fontSize: 14))),
                    DataCell(Text(animal.edad, style: GoogleFonts.plusJakartaSans(fontSize: 14))),
                    DataCell(Text(animal.peso, style: GoogleFonts.plusJakartaSans(fontSize: 14))),
                    DataCell(_buildSyncBadge(animal.estadoSincronizacion)),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w800,
        color: textMuted,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40.0),
      child: Center(
        child: Column(
          children: [
            const Icon(Icons.pets_outlined, size: 48, color: textMuted),
            const SizedBox(height: 12),
            Text(
              'No hay animales registrados en el sistema',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSyncBadge(String estado) {
    bool isSynced = estado == 'Sincronizado';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSynced ? const Color(0xFFECFDF5) : const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        estado,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: isSynced ? const Color(0xFF059669) : const Color(0xFFD97706),
        ),
      ),
    );
  }

  // --- MODAL DE REGISTRO HU-006 ---
  void _mostrarModalRegistrarAnimal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        title: Text(
          'Registrar Nuevo Animal (HU-006)',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, color: primaryColor),
        ),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Chapeta / Arete Único',
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Especie (Ej: Bovino, Bufalino)',
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Raza (Ej: Brahman, Holstein)',
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Sexo',
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Edad',
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Peso (kg)',
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, color: textMuted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Animal registrado localmente / Sincronizado')),
              );
            },
            child: Text('Guardar Animal', style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
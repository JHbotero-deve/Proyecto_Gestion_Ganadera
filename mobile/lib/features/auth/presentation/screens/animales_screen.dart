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
    this.totalAnimales = '3',
    this.sincronizadosCount = '2',
    this.pendientesCount = '1',
    this.animales = const [
      AnimalRecord(
        id: '1',
        chapeta: 'CH-1024',
        especie: 'Bovino',
        raza: 'Brahman',
        sexo: 'Macho',
        edad: '24 meses',
        peso: '450 kg',
        estadoSincronizacion: 'Sincronizado',
      ),
      AnimalRecord(
        id: '2',
        chapeta: 'CH-1025',
        especie: 'Bovino',
        raza: 'Holstein',
        sexo: 'Hembra',
        edad: '18 meses',
        peso: '380 kg',
        estadoSincronizacion: 'Sincronizado',
      ),
      AnimalRecord(
        id: '3',
        chapeta: 'CH-1026',
        especie: 'Bovino',
        raza: 'Gyr',
        sexo: 'Hembra',
        edad: '30 meses',
        peso: '420 kg',
        estadoSincronizacion: 'Pendiente Local',
      ),
    ],
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

  // Controlador para el campo de filtro por Chapeta
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Filtrado dinámico de animales por chapeta
  List<AnimalRecord> get _filteredAnimales {
    if (_searchQuery.isEmpty) {
      return widget.animales;
    }
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
              'Registro de Animales',
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

  // Seccion de Tabla + Buscador por Chapeta
  Widget _buildDataTableSection(BuildContext context) {
    final animalesMostrados = _filteredAnimales;

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
          // Encabezado con título y Campo de Filtro por Chapeta
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
              SizedBox(
                width: 280,
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Buscar por chapeta...',
                    hintStyle: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: textMuted,
                    ),
                    prefixIcon: const Icon(Icons.search_rounded, color: primaryColor, size: 20),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                      icon: const Icon(Icons.clear_rounded, size: 18, color: textMuted),
                      onPressed: () => _searchController.clear(),
                    )
                        : null,
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: borderColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: primaryColor, width: 1.5),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Tabla de Datos
          animalesMostrados.isEmpty
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
                DataColumn(label: _buildTableHeader('ACCIONES')),
              ],
              rows: animalesMostrados.map((animal) {
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
                    DataCell(
                      IconButton(
                        icon: const Icon(Icons.visibility_outlined, color: primaryColor, size: 20),
                        tooltip: 'Ver Detalle del Animal',
                        onPressed: () => _mostrarModalDetalleAnimal(context, animal),
                      ),
                    ),
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
            const Icon(Icons.search_off_rounded, size: 48, color: textMuted),
            const SizedBox(height: 12),
            Text(
              _searchQuery.isEmpty
                  ? 'No hay animales registrados en el sistema'
                  : 'No se encontró ningún animal con la chapeta "$_searchQuery"',
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

  // --- MODAL DETALLE DE ANIMAL ---
  void _mostrarModalDetalleAnimal(BuildContext context, AnimalRecord animal) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.pets_rounded, color: primaryColor, size: 24),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ficha del Animal',
                  style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 18, color: primaryColor),
                ),
                Text(
                  'Chapeta: ${animal.chapeta}',
                  style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 13, color: textMuted),
                ),
              ],
            ),
          ],
        ),
        content: SizedBox(
          width: 380,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Divider(color: borderColor),
              const SizedBox(height: 12),
              _buildDetailRow('Especie', animal.especie, Icons.category_outlined),
              _buildDetailRow('Raza', animal.raza, Icons.dns_outlined),
              _buildDetailRow('Sexo', animal.sexo, Icons.female_outlined),
              _buildDetailRow('Edad', animal.edad, Icons.cake_outlined),
              _buildDetailRow('Peso', animal.peso, Icons.monitor_weight_outlined),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Estado:', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, color: textMuted)),
                  _buildSyncBadge(animal.estadoSincronizacion),
                ],
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: () => Navigator.pop(context),
            child: Text('Cerrar', style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: accentColor),
          const SizedBox(width: 10),
          Text('$label:', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, color: textMuted, fontSize: 14)),
          const Spacer(),
          Text(value, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, color: primaryColor, fontSize: 14)),
        ],
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
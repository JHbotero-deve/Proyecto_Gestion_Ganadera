import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Modelo ligero para recibir los datos de cada registro desde el Backend.
class RegistroSanitario {
  final String codigo;
  final String arete;
  final String evento;
  final String fecha;
  final String veterinario;
  final String estado;
  final String tipoEstado; // 'success', 'warning', 'danger', 'info'

  const RegistroSanitario({
    required this.codigo,
    required this.arete,
    required this.evento,
    required this.fecha,
    required this.veterinario,
    required this.estado,
    required this.tipoEstado,
  });
}

class SanidadScreen extends StatelessWidget {
  // Parámetros que llenarán tus compañeros desde el Backend / Controller
  final String vacunacionPorcentaje;
  final String controlesPendientes;
  final String alertasSanitarias;
  final List<RegistroSanitario> registros;
  final VoidCallback? onRegistrarEventoPressed;
  final ValueChanged<RegistroSanitario>? onVerDetallesPressed;
  final ValueChanged<RegistroSanitario>? onEditarPressed;

  const SanidadScreen({
    Key? key,
    this.vacunacionPorcentaje = '0.0%',
    this.controlesPendientes = '0',
    this.alertasSanitarias = '0',
    this.registros = const [],
    this.onRegistrarEventoPressed,
    this.onVerDetallesPressed,
    this.onEditarPressed,
  }) : super(key: key);

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
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
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

  // Encabezado del Módulo
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Módulo de Sanidad e Intermediación ICA',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Gestión y trazabilidad sanitaria oficial para el control ganadero.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: textMuted,
              ),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: onRegistrarEventoPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 2,
          ),
          icon: const Icon(Icons.add_circle_outline_rounded, size: 20),
          label: Text(
            'Registrar Evento',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
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
              title: 'Vacunación Vigente',
              value: vacunacionPorcentaje,
              subtitle: 'Reportado ante el ICA',
              icon: Icons.shield_rounded,
              iconBgColor: const Color(0xFFECFDF5),
              iconColor: const Color(0xFF059669),
            ),
            SizedBox(height: isWide ? 0 : 16, width: isWide ? 16 : 0),
            _buildKpiCard(
              title: 'Controles Pendientes',
              value: controlesPendientes,
              subtitle: 'Próximos 30 días',
              icon: Icons.event_note_rounded,
              iconBgColor: const Color(0xFFFFFBEB),
              iconColor: const Color(0xFFD97706),
            ),
            SizedBox(height: isWide ? 0 : 16, width: isWide ? 16 : 0),
            _buildKpiCard(
              title: 'Alertas Sanitarias',
              value: alertasSanitarias,
              subtitle: 'Requiere atención',
              icon: Icons.warning_amber_rounded,
              iconBgColor: const Color(0xFFFEF2F2),
              iconColor: const Color(0xFFDC2626),
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

  // Sección de Tabla de Datos
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
                'Historial de Registros Sanitarios',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: primaryColor,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.filter_list_rounded, color: primaryColor),
                tooltip: 'Filtrar registros',
              ),
            ],
          ),
          const SizedBox(height: 16),
          registros.isEmpty
              ? _buildEmptyState()
              : SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: MaterialStateProperty.all(backgroundColor),
              dataRowHeight: 64,
              columns: [
                DataColumn(label: _buildTableHeader('CÓDIGO / ARETE')),
                DataColumn(label: _buildTableHeader('EVENTO SANITARIO')),
                DataColumn(label: _buildTableHeader('FECHA')),
                DataColumn(label: _buildTableHeader('VETERINARIO')),
                DataColumn(label: _buildTableHeader('ESTADO')),
                DataColumn(label: _buildTableHeader('ACCIONES')),
              ],
              rows: registros.map((registro) {
                return DataRow(
                  cells: [
                    DataCell(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            registro.codigo,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: primaryColor,
                            ),
                          ),
                          Text(
                            registro.arete,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    DataCell(
                      Text(
                        registro.evento,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        registro.fecha,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        registro.veterinario,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    DataCell(_buildStatusBadge(registro.estado, registro.tipoEstado)),
                    DataCell(
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.visibility_outlined, size: 20, color: accentColor),
                            onPressed: () => onVerDetallesPressed?.call(registro),
                            tooltip: 'Ver detalles',
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, size: 20, color: textMuted),
                            onPressed: () => onEditarPressed?.call(registro),
                            tooltip: 'Editar',
                          ),
                        ],
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

  // Componente si no hay registros o mientras carga el Backend
  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40.0),
      child: Center(
        child: Column(
          children: [
            const Icon(Icons.folder_open_rounded, size: 48, color: textMuted),
            const SizedBox(height: 12),
            Text(
              'No hay registros sanitarios disponibles',
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

  // Badges de Estado
  Widget _buildStatusBadge(String text, String type) {
    Color bgColor;
    Color textColor;

    switch (type) {
      case 'success':
        bgColor = const Color(0xFFECFDF5);
        textColor = const Color(0xFF059669);
        break;
      case 'warning':
        bgColor = const Color(0xFFFFFBEB);
        textColor = const Color(0xFFD97706);
        break;
      case 'danger':
        bgColor = const Color(0xFFFEF2F2);
        textColor = const Color(0xFFDC2626);
        break;
      case 'info':
      default:
        bgColor = const Color(0xFFEFF6FF);
        textColor = const Color(0xFF2563EB);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }
}
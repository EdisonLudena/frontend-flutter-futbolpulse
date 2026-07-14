import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../providers/repository_providers.dart';
import '../../providers/auth_provider.dart';
import '../../../domain/model/reporte_scouting.dart';
import '../../../domain/model/metrica_tecnica.dart';
import '../../../domain/model/metrica_tactica.dart';
import 'scouting_reports_screen.dart';
import 'scouting_dashboard_screen.dart';
import '../players/players_screen.dart';

final reportMetricsProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, reporteId) async {
  final repo = ref.read(scoutingRepositoryProvider);
  final tech = await repo.getMetricasTecnicas(reporteId);
  final tact = await repo.getMetricasTacticas(reporteId);
  return {'tech': tech, 'tact': tact};
});

class ReportDetailScreen extends ConsumerWidget {
  final ReporteScouting reporte;

  const ReportDetailScreen({super.key, required this.reporte});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metricsAsync = ref.watch(reportMetricsProvider(reporte.id));
    final prospectosAsync = ref.watch(prospectosProvider);
    final jugadoresAsync = ref.watch(playersProvider);
    final user = ref.watch(authProvider).user;
    final isScout = user?.tipoUsuario == 'Scout';

    // Identificar el nombre del sujeto evaluado
    String sujetoNombre = 'INFORME TÉCNICO';
    final prospectos = prospectosAsync.value ?? [];
    final jugadores = jugadoresAsync.value ?? [];

    if (reporte.prospectoId != null) {
      final p = prospectos.where((x) => x.id == reporte.prospectoId).firstOrNull;
      sujetoNombre = p?.nombreJugador ?? 'PROSPECTO';
    } else if (reporte.jugadorId != null) {
      final j = jugadores.where((x) => x.id == reporte.jugadorId).firstOrNull;
      sujetoNombre = j?.nombreCompleto ?? 'JUGADOR';
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (isScout) ...[
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => _showEditDialog(context, ref),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.white70),
              onPressed: () => _confirmDelete(context, ref),
            ),
          ]
        ],
      ),
      body: Column(
        children: [
          // Header con Gradiente Esmeralda
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 110, 24, 40),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.pitchPrimary, Color(0xFF2D6A4F)],
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
            ),
            child: Column(
              children: [
                const Icon(Icons.analytics_outlined, size: 40, color: Colors.white24),
                const SizedBox(height: 16),
                Text(sujetoNombre.toUpperCase(), 
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
                const SizedBox(height: 8),
                Text(reporte.partidoObservado?.toUpperCase() ?? 'OBSERVACIÓN GENERAL', 
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.goldLight, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (i) => Icon(
                    i < reporte.valoracionEstrellas ? Icons.star : Icons.star_border,
                    color: AppColors.gold,
                    size: 20,
                  )),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('COMENTARIO TÉCNICO'),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20)],
                    ),
                    child: Text(
                      reporte.comentarioTecnico ?? 'Sin comentarios adicionales.',
                      style: const TextStyle(color: Colors.black87, fontSize: 14, height: 1.6, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 32),
                  metricsAsync.when(
                    data: (metrics) => Column(
                      children: [
                        _buildMetricsSection('RENDIMIENTO TÉCNICO', metrics['tech'] as MetricaTecnica?, isTech: true),
                        const SizedBox(height: 32),
                        _buildMetricsSection('ANÁLISIS TÁCTICO', metrics['tact'] as MetricaTactica?, isTech: false),
                      ],
                    ),
                    loading: () => const Center(child: CircularProgressIndicator(color: AppColors.pitchPrimary)),
                    error: (e, _) => Center(child: Text('Error al cargar métricas: $e')),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: AppTextStyles.sectionTitle());
  }

  Widget _buildMetricsSection(String title, dynamic metrics, {required bool isTech}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.black.withOpacity(0.02)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.sectionTitle()),
          const SizedBox(height: 20),
          if (metrics == null)
            const Text('No se registraron datos.', style: TextStyle(color: Colors.black26, fontSize: 12))
          else if (isTech)
            ..._buildTechBars(metrics as MetricaTecnica)
          else
            ..._buildTactBars(metrics as MetricaTactica),
        ],
      ),
    );
  }

  List<Widget> _buildTechBars(MetricaTecnica tech) {
    return [
      _MetricBar(label: 'CONTROL', value: (tech.control ?? 0).toDouble()),
      _MetricBar(label: 'PASE CORTO', value: (tech.paseCorto ?? 0).toDouble()),
      _MetricBar(label: 'PASE LARGO', value: (tech.paseLargo ?? 0).toDouble()),
      _MetricBar(label: 'TIRO', value: (tech.tiro ?? 0).toDouble()),
      _MetricBar(label: 'REGATE', value: (tech.regate ?? 0).toDouble()),
      _MetricBar(label: 'VELOCIDAD', value: (tech.velocidad ?? 0).toDouble()),
    ];
  }

  List<Widget> _buildTactBars(MetricaTactica tact) {
    return [
      _MetricBar(label: 'UBICACIÓN', value: (tact.ubicacion ?? 0).toDouble()),
      _MetricBar(label: 'LECTURA', value: (tact.lecturaJuego ?? 0).toDouble()),
      _MetricBar(label: 'SACRIFICIO', value: (tact.sacrificio ?? 0).toDouble()),
      _MetricBar(label: 'LIDERAZGO', value: (tact.liderazgo ?? 0).toDouble()),
      _MetricBar(label: 'PRESIÓN', value: (tact.presion ?? 0).toDouble()),
      _MetricBar(label: 'TRABAJO EQUIPO', value: (tact.trabajoEquipo ?? 0).toDouble()),
    ];
  }

  void _showEditDialog(BuildContext context, WidgetRef ref) {
    final partidoCtrl = TextEditingController(text: reporte.partidoObservado);
    final commentCtrl = TextEditingController(text: reporte.comentarioTecnico);
    int stars = reporte.valoracionEstrellas;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('EDITAR INFORME', style: AppTextStyles.sectionTitle(color: AppColors.pitchPrimary)),
              const SizedBox(height: 24),
              TextField(
                controller: partidoCtrl,
                decoration: const InputDecoration(labelText: 'Partido Observado'),
              ),
              const SizedBox(height: 20),
              const Text('Valoración', style: TextStyle(fontSize: 12, color: Colors.black38, fontWeight: FontWeight.bold)),
              Row(
                children: List.generate(5, (i) => IconButton(
                  icon: Icon(i < stars ? Icons.star : Icons.star_border, color: AppColors.gold),
                  onPressed: () => setModalState(() => stars = i + 1),
                )),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: commentCtrl,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Comentario Técnico'),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () async {
                  await ref.read(scoutingRepositoryProvider).updateReporte(reporte.id, {
                    'partido_observado': partidoCtrl.text,
                    'valoracion_estrellas': stars,
                    'comentario_tecnico': commentCtrl.text,
                  });
                  ref.invalidate(scoutingReportsProvider);
                  if (context.mounted) {
                    Navigator.pop(context);
                    context.pop(); 
                  }
                },
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 56)),
                child: const Text('GUARDAR CAMBIOS'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('¿Eliminar Informe?'),
        content: const Text('Esta acción borrará permanentemente los datos del informe técnico.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCELAR')),
          TextButton(
            onPressed: () async {
              await ref.read(scoutingRepositoryProvider).deleteReporte(reporte.id);
              ref.invalidate(scoutingReportsProvider);
              if (context.mounted) {
                Navigator.pop(context);
                Navigator.pop(context);
              }
            },
            child: const Text('ELIMINAR', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class _MetricBar extends StatelessWidget {
  final String label;
  final double value;

  const _MetricBar({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 10, color: Colors.black45, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
              Text('${value.toInt()}%', style: const TextStyle(color: AppColors.pitchPrimary, fontWeight: FontWeight.w900, fontSize: 10)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value / 100,
              backgroundColor: AppColors.pitchPrimary.withOpacity(0.05),
              color: AppColors.gold,
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}

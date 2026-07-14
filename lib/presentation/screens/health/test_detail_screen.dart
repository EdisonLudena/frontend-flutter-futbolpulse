import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/model/test_rendimiento.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../providers/repository_providers.dart';
import 'health_screen.dart';

class TestDetailScreen extends ConsumerWidget {
  final TestRendimiento test;
  const TestDetailScreen({super.key, required this.test});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerMap = ref.watch(playersMapProvider).value ?? {};
    final playerName = playerMap[test.jugadorId] ?? 'Cargando...';

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Rendimiento Físico'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _confirmDelete(context, ref),
          ),
        ],
      ),
      body: Column(
        children: [
          // Header con Gradiente Deportivo
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 120, 24, 40),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF2D6A4F), AppColors.pitchPrimary],
              ),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
            ),
            child: Column(
              children: [
                const Icon(Icons.speed, size: 60, color: Colors.white24),
                const SizedBox(height: 16),
                Text(playerName.toUpperCase(), 
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
                const SizedBox(height: 8),
                Text('TEST DE CAMPO - ${test.fechaTest.toString().substring(0, 10)}', 
                  style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
              ],
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Cuadrícula de Métricas de Impacto
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.3,
                    children: [
                      _buildMetricCard('VELOCIDAD 30M', '${test.velocidad30mSeg ?? 0}', 'SEG'),
                      _buildMetricCard('VELOCIDAD 60M', '${test.velocidad60mSeg ?? 0}', 'SEG'),
                      _buildMetricCard('SALTO VERT.', '${test.saltoVerticalCm ?? 0}', 'CM'),
                      _buildMetricCard('VO2 MÁXIMO', '${test.resistenciaVo2max ?? 0}', 'ML'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Observaciones
                  _buildObservationCard(test.observaciones),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String label, String value, String unit) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Colors.black38)),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value, style: AppTextStyles.scoreboard(size: 32)),
              const SizedBox(width: 2),
              Text(unit, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black26)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildObservationCard(String? obs) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.black.withOpacity(0.03)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.comment_outlined, size: 16, color: AppColors.pitchPrimary),
              const SizedBox(width: 8),
              Text('OBSERVACIONES DEL TEST', style: AppTextStyles.sectionTitle()),
            ],
          ),
          const SizedBox(height: 12),
          Text(obs ?? 'Sin comentarios registrados.', 
            style: const TextStyle(fontSize: 14, color: Colors.black54, height: 1.5)),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('¿Eliminar Resultados?'),
        content: const Text('Esta acción borrará permanentemente los datos del test de rendimiento.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCELAR')),
          TextButton(
            onPressed: () async {
              await ref.read(healthRepositoryProvider).deleteTestRendimiento(test.id);
              ref.invalidate(allTestsProvider);
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

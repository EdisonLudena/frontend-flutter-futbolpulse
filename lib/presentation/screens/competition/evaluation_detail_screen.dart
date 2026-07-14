import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/model/evaluacion_post_partido.dart';
import '../../../theme/app_colors.dart';
import '../../providers/repository_providers.dart';
import 'evaluations_screen.dart';
import 'create_evaluation_screen.dart';

class EvaluationDetailScreen extends ConsumerWidget {
  final EvaluacionPostPartido evaluacion;
  const EvaluationDetailScreen({super.key, required this.evaluacion});

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Eliminar Evaluación?'),
        content: const Text('Esta acción borrará la nota permanentemente.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCELAR')),
          TextButton(
            onPressed: () async {
              await ref.read(competitionRepositoryProvider).deleteEvaluacion(evaluacion.id);
              ref.invalidate(evaluationsProvider);
              if (context.mounted) {
                context.pop(); // Cerrar diálogo
                context.pop(); // Volver a la lista
              }
            },
            child: const Text('ELIMINAR', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Evaluación'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CreateEvaluationScreen(evaluacionParaEditar: evaluacion)),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.error),
            onPressed: () => _confirmDelete(context, ref),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  const Text('CALIFICACIÓN FINAL', style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold, fontSize: 10)),
                  const SizedBox(height: 12),
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.gold,
                    child: Text(
                      evaluacion.calificacion.toStringAsFixed(1),
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            _EvalSection(title: 'PUNTOS POSITIVOS', content: evaluacion.puntosPositivos ?? 'Sin comentarios registrados.', color: AppColors.success),
            const SizedBox(height: 24),
            _EvalSection(title: 'PUNTOS A MEJORAR', content: evaluacion.puntosAMejorar ?? 'Sin sugerencias registradas.', color: AppColors.warning),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.surfaceDark, borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  Icon(evaluacion.esVisibleJugador ? Icons.visibility : Icons.visibility_off, color: Colors.white70),
                  const SizedBox(width: 12),
                  Text(
                    evaluacion.esVisibleJugador ? 'El jugador puede ver esta nota' : 'Solo el cuerpo técnico ve esta nota',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EvalSection extends StatelessWidget {
  final String title;
  final String content;
  final Color color;

  const _EvalSection({required this.title, required this.content, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1.2)),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: AppColors.surfaceDark, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.lineDark)),
          child: Text(content, style: const TextStyle(height: 1.5)),
        ),
      ],
    );
  }
}

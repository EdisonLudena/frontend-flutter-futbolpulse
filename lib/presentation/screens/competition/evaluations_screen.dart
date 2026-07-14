import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/repository_providers.dart';
import 'create_evaluation_screen.dart';
import '../../../theme/app_colors.dart';
import '../../../domain/model/evaluacion_post_partido.dart';
import '../../../domain/model/partido.dart';
import '../../../domain/model/jugador.dart';

// Este provider ahora combina las 3 listas para resolver los nombres en memoria
final resolvedEvaluationsProvider = FutureProvider<List<EvaluacionPostPartido>>((ref) async {
  final repo = ref.read(competitionRepositoryProvider);
  
  // Cargamos todo en paralelo para máxima velocidad
  final results = await Future.wait([
    repo.getEvaluaciones(),
    repo.getPartidos(),
    repo.getJugadores(),
  ]);

  final evaluations = results[0] as List<EvaluacionPostPartido>;
  final matches = results[1] as List<Partido>;
  final players = results[2] as List<Jugador>;

  // Cruzamos los datos
  return evaluations.map((ev) {
    final match = matches.where((m) => m.id == ev.partidoId).firstOrNull;
    final player = players.where((p) => p.id == ev.jugadorId).firstOrNull;
    
    return EvaluacionPostPartido(
      id: ev.id,
      partidoId: ev.partidoId,
      jugadorId: ev.jugadorId,
      calificacion: ev.calificacion,
      puntosPositivos: ev.puntosPositivos,
      puntosAMejorar: ev.puntosAMejorar,
      esVisibleJugador: ev.esVisibleJugador,
      creadoEn: ev.creadoEn,
      nombreJugador: player?.nombreCompleto ?? "Jugador desconocido",
      rivalPartido: match?.rival ?? "Rival desconocido",
    );
  }).toList();
});

class EvaluationsScreen extends ConsumerWidget {
  const EvaluationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Usamos el nuevo provider con nombres resueltos
    final evalsAsync = ref.watch(resolvedEvaluationsProvider);

    return Scaffold(
      body: evalsAsync.when(
        data: (evals) => evals.isEmpty 
          ? const Center(child: Text('No hay evaluaciones registradas todavía.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: evals.length,
              itemBuilder: (context, index) {
                final ev = evals[index];
                return GestureDetector(
                  onTap: () => context.push('/evaluation-detail', extra: ev),
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.gold,
                          child: Text(
                            ev.calificacion.toStringAsFixed(1), 
                            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13)
                          ),
                        ),
                        title: Text(
                          '${ev.nombreJugador} - vs ${ev.rivalPartido}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(ev.puntosPositivos ?? 'Sin comentarios técnicos.'),
                            const SizedBox(height: 4),
                            Text(
                              ev.esVisibleJugador ? 'Visible para el jugador' : 'Evaluación privada',
                              style: TextStyle(
                                fontSize: 10, 
                                color: ev.esVisibleJugador ? AppColors.success : AppColors.textOnDarkMuted
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
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, __) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab_evaluations',
        onPressed: () => context.push('/create-evaluation'),
        backgroundColor: AppColors.gold,
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}

// Mantenemos el nombre original para compatibilidad con el refresh de CreateEvaluationScreen
final evaluationsProvider = resolvedEvaluationsProvider;

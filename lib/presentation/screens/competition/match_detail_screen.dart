import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/model/partido.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../providers/repository_providers.dart';
import '../../providers/subscription_provider.dart';
import '../../providers/ui_provider.dart';
import 'matches_screen.dart';

// Provider para cargar eventos del partido
final matchEventsProvider = FutureProvider.family<List<dynamic>, String>((ref, partidoId) async {
  return await ref.read(competitionRepositoryProvider).getEventosLive(partidoId);
});

class MatchDetailScreen extends ConsumerWidget {
  final Partido partido;
  const MatchDetailScreen({super.key, required this.partido});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPremium = ref.watch(subscriptionProvider).isPremium;
    // Escuchamos el provider de partidos para reaccionar a cambios en los goles
    final allMatchesAsync = ref.watch(matchesProvider);
    final currentMatch = allMatchesAsync.when(
      data: (list) => list.firstWhere((m) => m.id == partido.id, orElse: () => partido),
      loading: () => partido,
      error: (_, __) => partido,
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Ficha del Encuentro'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => context.push('/create-match', extra: currentMatch),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _confirmDelete(context, ref),
          ),
        ],
      ),
      body: Column(
        children: [
          // Scoreboard Header de Alto Impacto
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 110, 24, 40),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.pitchPrimary, Color(0xFF0B2018)],
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
            ),
            child: Column(
              children: [
                Text(
                  currentMatch.tipoPartido?.toUpperCase() ?? 'LIGA',
                  style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 2),
                ),
                const SizedBox(height: 24),
                
                // Marcador con Controles (Flechas de Goles)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: _buildTeamName('CLUB QUITO FC')),
                    
                    // Columna Local con Flechas
                    _buildScoreController(ref, currentMatch, isLocal: true, isPremium: isPremium),
                    
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(':', style: TextStyle(color: AppColors.gold, fontSize: 32, fontWeight: FontWeight.bold)),
                    ),
                    
                    // Columna Visitante con Flechas
                    _buildScoreController(ref, currentMatch, isLocal: false, isPremium: isPremium),
                    
                    Expanded(child: _buildTeamName('${currentMatch.equipoLocal} vs ${currentMatch.equipoVisitante}'.toUpperCase())),
                  ],
                ),
                
                const SizedBox(height: 32),
                
                // Botón de Rastreo en Vivo (Premium)
                if (isPremium)
                  ElevatedButton(
                    onPressed: () => context.push('/live-tracker', extra: currentMatch),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.gold,
                      foregroundColor: Colors.black,
                      minimumSize: const Size(200, 45),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.sensors, size: 18),
                        SizedBox(width: 8),
                        Text('RASTREO EN VIVO', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                  )
                else
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.lock_outline, color: AppColors.gold, size: 14),
                      SizedBox(width: 8),
                      Text('RASTREO PREMIUM', style: TextStyle(color: AppColors.gold, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                    ],
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
                  _buildMatchInfoCard(currentMatch),
                  
                  if (isPremium) ...[
                    const SizedBox(height: 24),
                    Text('CRONOLOGÍA DEL JUEGO', style: AppTextStyles.sectionTitle()),
                    const SizedBox(height: 16),
                    _buildTimelineList(ref, currentMatch),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreController(WidgetRef ref, Partido m, {required bool isLocal, required bool isPremium}) {
    final score = isLocal ? m.golesFavor : m.golesContra;
    
    if (!isPremium) {
      return Text('$score', style: AppTextStyles.scoreboard(color: Colors.white, size: 48));
    }

    return Column(
      children: [
        IconButton(
          icon: const Icon(Icons.keyboard_arrow_up, color: AppColors.gold, size: 28),
          onPressed: () => _updateScore(ref, m, isLocal ? 1 : 0, isLocal ? 0 : 1),
        ),
        Text('$score', style: AppTextStyles.scoreboard(color: Colors.white, size: 48)),
        IconButton(
          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.gold, size: 28),
          onPressed: () => _updateScore(ref, m, isLocal ? -1 : 0, isLocal ? 0 : -1),
        ),
      ],
    );
  }

  Widget _buildTeamName(String name) {
    return Text(
      name,
      textAlign: TextAlign.center,
      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 0.5),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildMatchInfoCard(Partido m) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20)],
      ),
      child: Column(
        children: [
          _buildInfoRow(Icons.calendar_month_outlined, 'FECHA', m.fecha.toString().substring(0, 10)),
          const Divider(height: 32, color: Color(0xFFF1F3F5)),
          _buildInfoRow(Icons.info_outline, 'ESTADO', m.estadoPartido.toUpperCase()),
          const Divider(height: 32, color: Color(0xFFF1F3F5)),
          _buildInfoRow(Icons.history_outlined, 'OBSERVACIONES', m.observaciones ?? 'Sin notas adicionales.'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.pitchPrimary.withOpacity(0.4)),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.black38)),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black87)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineList(WidgetRef ref, Partido m) {
    final eventsAsync = ref.watch(matchEventsProvider(m.id));

    return eventsAsync.when(
      data: (events) => events.isEmpty
          ? Container(
              padding: const EdgeInsets.all(32),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: Colors.black.withOpacity(0.03)),
              ),
              child: const Column(
                children: [
                  Icon(Icons.timeline, color: Colors.black12, size: 40),
                  SizedBox(height: 12),
                  Text('No hay eventos registrados',
                      style: TextStyle(color: Colors.black26, fontSize: 11, fontWeight: FontWeight.bold)),
                ],
              ),
            )
          : ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: events.length,
              itemBuilder: (context, index) {
                final e = events[index];
                return ListTile(
                  dense: true,
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: AppColors.pitchPrimary.withOpacity(0.05), shape: BoxShape.circle),
                    child: Text('${e['minuto']}\'', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.pitchPrimary, fontSize: 12)),
                  ),
                  title: Text(e['tipo_evento'] ?? 'Evento', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: Text(e['descripcion'] ?? '', style: const TextStyle(fontSize: 12)),
                );
              },
            ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, __) => Text('Error: $e'),
    );
  }

  Future<void> _updateScore(WidgetRef ref, Partido m, int diffFavor, int diffContra) async {
    final nuevoFavor = (m.golesFavor + diffFavor).clamp(0, 99);
    final nuevoContra = (m.golesContra + diffContra).clamp(0, 99);
    
    try {
      await ref.read(competitionRepositoryProvider).updatePartido(m.id, {
        'goles_favor': nuevoFavor,
        'goles_contra': nuevoContra,
        'resultado_final': '$nuevoFavor-$nuevoContra',
      });
      // Invalidamos el provider para forzar la recarga del partido y reflejar el marcador
      ref.invalidate(matchesProvider);
    } catch (e) {
      print('Error al actualizar marcador: $e');
    }
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('¿Eliminar Partido?'),
        content: const Text('Esta acción borrará el resultado y las estadísticas del encuentro.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCELAR')),
          TextButton(
            onPressed: () async {
              await ref.read(competitionRepositoryProvider).deletePartido(partido.id);
              ref.invalidate(matchesProvider);
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

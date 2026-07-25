import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/repository_providers.dart';
import '../../providers/ui_provider.dart';
import '../../providers/subscription_provider.dart';
import '../../../domain/model/partido.dart';
import '../../../theme/app_colors.dart';
import '../../../core/utils/formatters.dart';

// Provider de partidos con filtrado por categorías del club activo
final matchesProvider = FutureProvider<List<Partido>>((ref) async {
  final allMatches = await ref.read(competitionRepositoryProvider).getPartidos();
  final isPremium = ref.watch(subscriptionProvider).isPremium;
  
  if (isPremium) {
    // Obtenemos los IDs de las categorías que pertenecen al club seleccionado
    final activeCatIdsAsync = ref.watch(activeCategoryIdsProvider);
    
    return activeCatIdsAsync.maybeWhen(
      data: (catIds) {
        if (catIds.isEmpty) return [];
        // Filtramos: el partido se muestra si su categoría está en la lista del club seleccionado
        return allMatches.where((m) => catIds.contains(m.categoriaId)).toList();
      },
      orElse: () => [],
    );
  }
  
  return allMatches;
});

class MatchesScreen extends ConsumerWidget {
  const MatchesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matchesAsync = ref.watch(matchesProvider);

    return Scaffold(
      body: matchesAsync.when(
        data: (matches) => matches.isEmpty
            ? const Center(child: Text('No hay partidos para el equipo seleccionado.'))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: matches.length,
                itemBuilder: (context, index) {
                  final partido = matches[index];
                  return GestureDetector(
                    onTap: () => context.push('/match-detail', extra: partido),
                    child: _MatchCard(partido: partido),
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab_matches',
        onPressed: () => context.push('/create-match'),
        backgroundColor: AppColors.gold,
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}

class _MatchCard extends ConsumerWidget {
  final Partido partido;
  const _MatchCard({super.key, required this.partido});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeOrg = ref.watch(activeOrgProvider);
    final isPremium = ref.watch(subscriptionProvider).isPremium;
    final teamName = (isPremium && activeOrg != null) ? activeOrg.nombreEntidad : 'MI EQUIPO';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(partido.tipoPartido.toUpperCase(), style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold, fontSize: 10)),
                Text(partido.estadoPartido, style: TextStyle(color: partido.estadoPartido == 'Finalizado' ? AppColors.success : AppColors.info, fontWeight: FontWeight.bold, fontSize: 10)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: Text(partido.equipoLocal, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold))),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.lineDark, borderRadius: BorderRadius.circular(8)),
                  child: Text('${partido.golesFavor} - ${partido.golesContra}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                Expanded(child: Text(partido.equipoVisitante, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold))),
              ],
            ),
            const SizedBox(height: 12),
            Text(AppFormatters.formatDateTime(partido.fecha), style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

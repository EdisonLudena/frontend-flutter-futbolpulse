import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/repository_providers.dart';
import '../../../domain/model/jugador.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

import '../../providers/ui_provider.dart';
import '../../providers/subscription_provider.dart';
import 'lineup_tab.dart'; // Importaremos el nuevo tab

final playersProvider = FutureProvider<List<Jugador>>((ref) async {
  final players = await ref.read(playerRepositoryProvider).getJugadores();
  final activeOrg = ref.watch(activeOrgProvider);
  final isPremium = ref.watch(subscriptionProvider).isPremium;

  if (isPremium && activeOrg != null) {
    return players.where((j) => j.entidadId == activeOrg.id).toList();
  }
  
  if (!isPremium && players.isNotEmpty) {
     final firstTeamId = players.first.entidadId;
     return players.where((j) => j.entidadId == firstTeamId).toList();
  }

  return players;
});

class PlayersScreen extends ConsumerWidget {
  const PlayersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPremium = ref.watch(subscriptionProvider).isPremium;

    if (!isPremium) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Plantilla'),
          backgroundColor: AppColors.pitchPrimary,
          foregroundColor: Colors.white,
        ),
        body: const _PlayersListTab(),
        floatingActionButton: FloatingActionButton(
          heroTag: 'fab_players_basic',
          onPressed: () => context.push('/create-player'),
          backgroundColor: AppColors.gold,
          child: const Icon(Icons.person_add, color: Colors.black),
        ),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            color: AppColors.pitchPrimary,
            child: TabBar(
              indicatorColor: AppColors.gold,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white60,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              tabs: const [
                Tab(text: 'JUGADORES', icon: Icon(Icons.group_outlined, size: 18)),
                Tab(text: 'ALINEACIONES', icon: Icon(Icons.grid_view_rounded, size: 18)),
              ],
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            _PlayersListTab(),
            LineupTab(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: 'fab_players',
          onPressed: () => context.push('/create-player'),
          backgroundColor: AppColors.gold,
          child: const Icon(Icons.person_add, color: Colors.black),
        ),
      ),
    );
  }
}

class _PlayersListTab extends ConsumerWidget {
  const _PlayersListTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playersAsync = ref.watch(playersProvider);

    return playersAsync.when(
      data: (players) => players.isEmpty
          ? const Center(child: Text('No hay jugadores en la plantilla.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: players.length,
              itemBuilder: (context, index) {
                final j = players[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    leading: CircleAvatar(
                      backgroundColor: AppColors.pitchPrimaryFaint,
                      child: Text(
                        j.numeroCamiseta?.toString() ?? '?',
                        style: const TextStyle(color: AppColors.pitchPrimary, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(j.nombreCompleto, style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.pitchPrimary)),
                    subtitle: Row(
                      children: [
                        Text(j.pieDominante, style: const TextStyle(fontSize: 12, color: Colors.black38)),
                        const SizedBox(width: 8),
                        _buildStatusBadge(j.estado),
                      ],
                    ),
                    trailing: const Icon(Icons.chevron_right, color: Colors.black12),
                    onTap: () => context.push('/player-detail', extra: j),
                  ),
                );
              },
            ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, __) => Center(child: Text('Error: $e')),
    );
  }

  Widget _buildStatusBadge(String estado) {
    final isLesionado = estado == 'Lesionado';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isLesionado ? AppColors.error.withOpacity(0.1) : AppColors.success.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        estado.toUpperCase(),
        style: TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.bold,
          color: isLesionado ? AppColors.error : AppColors.success,
        ),
      ),
    );
  }
}

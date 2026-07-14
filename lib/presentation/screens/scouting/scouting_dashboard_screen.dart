import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/premium_gate.dart';
import '../../../theme/app_colors.dart';
import '../../providers/repository_providers.dart';
import '../../providers/auth_provider.dart';
import 'prospect_detail_screen.dart';
import 'create_prospect_screen.dart';

final prospectosProvider = FutureProvider((ref) => ref.read(scoutingRepositoryProvider).getProspectos());

class ScoutingDashboardScreen extends ConsumerWidget {
  const ScoutingDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prospectosAsync = ref.watch(prospectosProvider);
    final user = ref.watch(authProvider).user;
    final isScout = user?.tipoUsuario == 'Scout';

    final body = Scaffold(
      appBar: AppBar(title: const Text('Scouting y Mercado')),
      body: prospectosAsync.when(
        data: (prospectos) => prospectos.isEmpty
          ? const Center(child: Text('No hay prospectos en seguimiento todavía.'))
          : ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: prospectos.length,
              itemBuilder: (context, index) {
                final p = prospectos[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: const CircleAvatar(backgroundColor: AppColors.pitchPrimary, child: Icon(Icons.person, color: Colors.white54)),
                    title: Text(p.nombreJugador ?? 'Jugador Desconocido', style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(p.equipoActual ?? 'Agente Libre'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.stars_rounded, color: AppColors.gold, size: 18),
                        const SizedBox(width: 4),
                        Text(p.estado, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProspectDetailScreen(prospecto: p))),
                  ),
                );
              },
            ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, __) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'scouting_fab_unique',
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateProspectScreen())),
        backgroundColor: AppColors.gold,
        child: const Icon(Icons.person_search_rounded, color: Colors.black),
      ),
    );

    // Si es Scout, acceso directo. Si es Coach, pasa por el portal Premium.
    if (isScout) return body;
    
    return PremiumGate(
      featureName: 'Módulo de Scouting Avanzado',
      child: body,
    );
  }
}

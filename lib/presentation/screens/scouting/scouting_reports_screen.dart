import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/app_colors.dart';
import '../../providers/repository_providers.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/premium_gate.dart';
import 'create_report_wizard.dart';
import 'scouting_dashboard_screen.dart';
import '../players/players_screen.dart';

final scoutingReportsProvider = FutureProvider((ref) {
  return ref.read(scoutingRepositoryProvider).getReportes();
});

class ScoutingReportsScreen extends ConsumerWidget {
  const ScoutingReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportsAsync = ref.watch(scoutingReportsProvider);
    final prospectosAsync = ref.watch(prospectosProvider);
    final jugadoresAsync = ref.watch(playersProvider);
    
    final user = ref.watch(authProvider).user;
    final isScout = user?.tipoUsuario == 'Scout';

    final body = Scaffold(
      appBar: AppBar(title: const Text('Reportes de Scouting')),
      body: reportsAsync.when(
        data: (reports) => reports.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.analytics_outlined, size: 64, color: Colors.white24),
                  SizedBox(height: 16),
                  Text('Sin reportes registrados', style: TextStyle(color: Colors.white54)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 48, vertical: 8),
                    child: Text('Toca el botón + para crear tu primer informe técnico.', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.white38)),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(scoutingReportsProvider);
                await ref.read(scoutingReportsProvider.future);
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(24),
                itemCount: reports.length,
                itemBuilder: (context, index) {
                  final r = reports[index];
                  
                  // Intentamos encontrar el nombre del sujeto
                  String sujetoNombre = 'Sujeto Desconocido';
                  
                  final prospectos = prospectosAsync.value ?? [];
                  final jugadores = jugadoresAsync.value ?? [];

                  if (r.prospectoId != null) {
                    final matchingProspects = prospectos.where((x) => x.id == r.prospectoId);
                    if (matchingProspects.isNotEmpty) {
                      final p = matchingProspects.first;
                      sujetoNombre = p.nombreJugador ?? 'S/N';
                    } else {
                      sujetoNombre = 'Prospecto (${r.prospectoId!.substring(0,8)})';
                    }
                  } else if (r.jugadorId != null) {
                    final matchingPlayers = jugadores.where((x) => x.id == r.jugadorId);
                    if (matchingPlayers.isNotEmpty) {
                      final j = matchingPlayers.first;
                      sujetoNombre = j.nombreCompleto;
                    } else {
                      sujetoNombre = 'Jugador (${r.jugadorId!.substring(0,8)})';
                    }
                  }

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: AppColors.pitchPrimaryLight,
                        child: Icon(Icons.description_outlined, color: AppColors.gold, size: 20),
                      ),
                      title: Text(sujetoNombre, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(r.partidoObservado ?? 'Sin partido especificado', style: const TextStyle(fontSize: 12)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              ...List.generate(5, (i) => Icon(
                                i < r.valoracionEstrellas ? Icons.star : Icons.star_border,
                                color: AppColors.gold,
                                size: 12,
                              )),
                            ],
                          ),
                        ],
                      ),
                      trailing: Text(r.fechaReporte.toString().substring(0, 10), style: const TextStyle(fontSize: 10, color: Colors.white38)),
                      onTap: () => context.push('/report-detail', extra: r),
                    ),
                  );
                },
              ),
            ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, __) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateReportWizard())),
        backgroundColor: AppColors.gold,
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );

    if (isScout) return body;

    return PremiumGate(
      featureName: 'Historial de Informes Técnicos',
      child: body,
    );
  }
}

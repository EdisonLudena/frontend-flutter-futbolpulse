import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../providers/repository_providers.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/premium_gate.dart';
import '../players/players_screen.dart';
import '../../../domain/model/valoracion_economica.dart';

// Notifier para centralizar todas las valoraciones y evitar múltiples llamadas repetitivas
class AllValuationsNotifier extends Notifier<Map<String, List<ValoracionEconomica>>> {
  @override
  Map<String, List<ValoracionEconomica>> build() => {};

  Future<void> load() async {
    try {
      final valuations = await ref.read(scoutingRepositoryProvider).getValoraciones(null);
      final Map<String, List<ValoracionEconomica>> grouped = {};
      
      for (var v in valuations) {
        if (!grouped.containsKey(v.jugadorId)) {
          grouped[v.jugadorId] = [];
        }
        grouped[v.jugadorId]!.add(v);
      }
      
      // Ordenamos cada lista por fecha y por ID para obtener la ÚLTIMA real
      grouped.forEach((key, list) {
        list.sort((a, b) {
          int cmp = b.fechaValoracion.compareTo(a.fechaValoracion);
          if (cmp == 0) return b.id.compareTo(a.id);
          return cmp;
        });
      });
      
      state = grouped;
    } catch (e) {
      print('Error cargando valoraciones: $e');
    }
  }
}

final allValuationsProvider = NotifierProvider<AllValuationsNotifier, Map<String, List<ValoracionEconomica>>>(() {
  return AllValuationsNotifier();
});

class EconomicValoracionScreen extends ConsumerStatefulWidget {
  const EconomicValoracionScreen({super.key});

  @override
  ConsumerState<EconomicValoracionScreen> createState() => _EconomicValoracionScreenState();
}

class _EconomicValoracionScreenState extends ConsumerState<EconomicValoracionScreen> {
  
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(allValuationsProvider.notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final playersAsync = ref.watch(playersProvider);
    final groupedValuations = ref.watch(allValuationsProvider);
    final user = ref.watch(authProvider).user;
    final isScout = user?.tipoUsuario == 'Scout';

    final body = DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          title: const Text('Valoración Económica'),
          bottom: const TabBar(
            indicatorColor: AppColors.gold,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white54,
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 0.5),
            tabs: [
              Tab(text: 'ACTIVOS DEL CLUB', icon: Icon(Icons.inventory_2_outlined, size: 18)),
              Tab(text: 'HISTORIAL', icon: Icon(Icons.history_outlined, size: 18)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildPlayersList(playersAsync, groupedValuations),
            _buildHistoryList(groupedValuations, playersAsync),
          ],
        ),
      ),
    );

    if (isScout) return body;

    return PremiumGate(
      featureName: 'Tasación Económica de Jugadores',
      child: body,
    );
  }

  Widget _buildPlayersList(AsyncValue playersAsync, Map<String, List<ValoracionEconomica>> grouped) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.gold.withOpacity(0.1), Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Row(
            children: const [
              Icon(Icons.info_outline, color: AppColors.gold, size: 24),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Activos actuales de la plantilla oficial. Pulsa un jugador para actualizar su valor de mercado.',
                  style: TextStyle(color: Colors.black45, fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: playersAsync.when(
            data: (players) => RefreshIndicator(
              onRefresh: () => ref.read(allValuationsProvider.notifier).load(),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: players.length,
                itemBuilder: (context, index) {
                  final j = players[index];
                  final valuations = grouped[j.id] ?? [];
                  final latest = valuations.isNotEmpty ? valuations.first : null;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      leading: CircleAvatar(
                        backgroundColor: AppColors.pitchPrimaryFaint,
                        child: const Icon(Icons.person, color: AppColors.pitchPrimary, size: 20),
                      ),
                      title: Text(j.nombreCompleto.toUpperCase(), 
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: AppColors.pitchPrimary)),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          latest != null 
                            ? 'VALOR: \$${latest.valorEstimado.toStringAsFixed(0)} ${latest.moneda}' 
                            : 'SIN TASACIÓN ACTUAL',
                          style: TextStyle(
                            color: latest != null ? AppColors.gold : Colors.black26,
                            fontSize: 11,
                            fontWeight: FontWeight.w800
                          ),
                        ),
                      ),
                      trailing: const Icon(Icons.edit_note_outlined, color: AppColors.gold, size: 20),
                      onTap: () => _showValuationForm(context, j.id, j.nombreCompleto, latest),
                    ),
                  );
                },
              ),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryList(Map<String, List<ValoracionEconomica>> grouped, AsyncValue playersAsync) {
    final allValuations = grouped.values.expand((x) => x).toList();
    allValuations.sort((a, b) {
      int cmp = b.fechaValoracion.compareTo(a.fechaValoracion);
      if (cmp == 0) return b.id.compareTo(a.id);
      return cmp;
    });

    if (allValuations.isEmpty) {
      return const Center(child: Text('No hay registros en el historial', style: TextStyle(color: Colors.black26, fontWeight: FontWeight.bold)));
    }

    final players = playersAsync.value ?? [];

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: allValuations.length,
      itemBuilder: (context, index) {
        final v = allValuations[index];
        final matchingPlayers = players.where((p) => p.id == v.jugadorId);
        final jugador = matchingPlayers.isNotEmpty ? matchingPlayers.first : null;
        
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black.withOpacity(0.02)),
          ),
          child: ListTile(
            dense: true,
            title: Text(jugador?.nombreCompleto.toUpperCase() ?? 'ID: ${v.jugadorId.substring(0,8)}', 
                style: const TextStyle(color: AppColors.pitchPrimary, fontWeight: FontWeight.w900, fontSize: 12)),
            subtitle: Text('${v.metodoValoracion ?? 'S/M'} | ${v.observaciones ?? 'Sin obs.'}', 
                maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10, color: Colors.black38)),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('\$${v.valorEstimado.toStringAsFixed(0)}', 
                    style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.gold, fontSize: 14)),
                Text(v.fechaValoracion.toString().substring(0, 10), 
                    style: const TextStyle(fontSize: 8, color: Colors.black26, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showValuationForm(BuildContext context, String playerId, String playerName, ValoracionEconomica? existing) {
    final valCtrl = TextEditingController(text: existing?.valorEstimado.toStringAsFixed(0));
    final obsCtrl = TextEditingController(text: existing?.observaciones);
    
    final List<String> metodos = [
      'Transfermarkt', 
      'CIES Football Obs.', 
      'Algoritmo Interno', 
      'Precio de Mercado', 
      'Análisis de mercado + rendimiento estadístico',
      'Análisis de Scout'
    ];
    
    String metodo = existing?.metodoValoracion ?? 'Transfermarkt';
    if (!metodos.contains(metodo)) metodos.add(metodo);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              existing == null ? 'NUEVA TASACIÓN: $playerName' : 'ACTUALIZAR TASACIÓN: $playerName', 
              style: const TextStyle(color: AppColors.pitchPrimary, fontWeight: FontWeight.w900, fontSize: 16)
            ),
            const SizedBox(height: 24),
            TextField(
              controller: valCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'VALOR ESTIMADO',
                prefixText: 'USD ',
                hintText: 'Ej: 58000',
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: metodo,
              decoration: const InputDecoration(labelText: 'MÉTODO DE VALORACIÓN'),
              items: metodos.map((m) => DropdownMenuItem(value: m, child: Text(m, style: const TextStyle(fontSize: 12)))).toList(),
              onChanged: (v) => metodo = v!,
              isExpanded: true,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: obsCtrl,
              maxLines: 2,
              decoration: const InputDecoration(labelText: 'OBSERVACIONES / JUSTIFICACIÓN'),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                final double? valor = double.tryParse(valCtrl.text);
                if (valor == null) return;

                try {
                  final Map<String, dynamic> data = {
                    'jugador': playerId,
                    'valor_estimado': valor, 
                    'moneda': 'USD',
                    'metodo_valoracion': metodo,
                    'observaciones': obsCtrl.text,
                    'fecha_valoracion': DateTime.now().toIso8601String().split('T')[0],
                  };

                  if (existing != null) {
                    await ref.read(scoutingRepositoryProvider).updateValoracion(existing.id, data);
                  } else {
                    await ref.read(scoutingRepositoryProvider).saveValoracion(data);
                  }
                  
                  await ref.read(allValuationsProvider.notifier).load();

                  if (mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Valoración guardada correctamente'), backgroundColor: AppColors.pitchPrimary)
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.error)
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 60)),
              child: Text(existing == null ? 'GUARDAR TASACIÓN' : 'ACTUALIZAR TASACIÓN'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../theme/app_colors.dart';
import '../../providers/repository_providers.dart';
import '../players/players_screen.dart';

class MarketValuationScreen extends ConsumerWidget {
  const MarketValuationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playersAsync = ref.watch(playersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Valoración de Mercado')),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            color: AppColors.gold.withOpacity(0.05),
            child: Row(
              children: const [
                Icon(Icons.info_outline, color: AppColors.gold, size: 20),
                SizedBox(width: 12),
                Expanded(child: Text('Asigna valores económicos a los jugadores basados en su proyección.', style: TextStyle(fontSize: 11, color: Colors.white70))),
              ],
            ),
          ),
          Expanded(
            child: playersAsync.when(
              data: (players) => ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: players.length,
                itemBuilder: (context, index) {
                  final j = players[index];
                  return Card(
                    child: ListTile(
                      title: Text(j.nombreCompleto, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: const Text('Valoración pendiente'),
                      trailing: const Icon(Icons.add_chart, color: AppColors.gold),
                      onTap: () => _showUpdateValueDialog(context, ref, j.id),
                    ),
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }

  void _showUpdateValueDialog(BuildContext context, WidgetRef ref, String playerId) {
    final valCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nueva Valoración'),
        content: TextField(
          controller: valCtrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Valor Estimado (USD)', prefixText: '\$ '),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCELAR')),
          ElevatedButton(
            onPressed: () async {
              await ref.read(scoutingRepositoryProvider).saveValoracion({
                'jugador': playerId,
                'valor_estimado': double.tryParse(valCtrl.text) ?? 0,
                'metodo_valoracion': 'Análisis de Scout',
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Valoración actualizada con éxito')));
            }, 
            child: const Text('GUARDAR')
          ),
        ],
      ),
    );
  }
}

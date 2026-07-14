import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../theme/app_colors.dart';
import '../../providers/repository_providers.dart';
import '../../../domain/model/entidad.dart';

import 'club_detail_screen.dart';

final entidadesProvider = FutureProvider<List<Entidad>>((ref) => ref.read(catalogRepositoryProvider).getEntidades());

class ClubManagementScreen extends ConsumerWidget {
  const ClubManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entidadesAsync = ref.watch(entidadesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mis Organizaciones')),
      body: entidadesAsync.when(
        data: (clubs) => ListView.builder(
          padding: const EdgeInsets.all(24),
          itemCount: clubs.length,
          itemBuilder: (context, i) => Card(
            child: ListTile(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ClubDetailScreen(club: clubs[i]))),
              leading: const Icon(Icons.business, color: AppColors.gold),
              title: Text(clubs[i].nombreEntidad),
              subtitle: Text('${clubs[i].ciudad}, ${clubs[i].pais}'),
              trailing: const Icon(Icons.chevron_right),
            ),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, __) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddClubDialog(context, ref),
        backgroundColor: AppColors.gold,
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }

  void _showAddClubDialog(BuildContext context, WidgetRef ref) {
    final nameCtrl = TextEditingController();
    final cityCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nueva Entidad/Club'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nombre del Club')),
            TextField(controller: cityCtrl, decoration: const InputDecoration(labelText: 'Ciudad')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCELAR')),
          TextButton(
            onPressed: () async {
              await ref.read(catalogRepositoryProvider).createEntidad({
                'nombre_entidad': nameCtrl.text,
                'ciudad': cityCtrl.text,
                'pais': 'Ecuador',
              });
              ref.invalidate(entidadesProvider);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('CREAR'),
          ),
        ],
      ),
    );
  }
}

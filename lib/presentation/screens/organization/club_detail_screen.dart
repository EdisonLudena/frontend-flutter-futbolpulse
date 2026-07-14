import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../providers/repository_providers.dart';
import '../../../domain/model/entidad.dart';
import '../../../domain/model/sede.dart';
import '../../../domain/model/categoria.dart';

final clubSedesProvider = FutureProvider.family<List<Sede>, String>((ref, clubId) => ref.read(catalogRepositoryProvider).getSedes(entidadId: clubId));
final clubCategoriasProvider = FutureProvider.family<List<Categoria>, String>((ref, clubId) => ref.read(catalogRepositoryProvider).getCategorias(entidadId: clubId));

class ClubDetailScreen extends ConsumerWidget {
  final Entidad club;
  const ClubDetailScreen({super.key, required this.club});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sedesAsync = ref.watch(clubSedesProvider(club.id));
    final categoriasAsync = ref.watch(clubCategoriasProvider(club.id));

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(club.nombreEntidad),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.white70),
              onPressed: () => _confirmDeleteClub(context, ref),
            ),
          ],
          bottom: const TabBar(
            indicatorColor: AppColors.gold,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1),
            tabs: [
              Tab(text: 'SEDES', icon: Icon(Icons.location_on_outlined, size: 20)),
              Tab(text: 'CATEGORÍAS', icon: Icon(Icons.group_outlined, size: 20)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _SedesTab(sedesAsync: sedesAsync, clubId: club.id),
            _CategoriasTab(categoriasAsync: categoriasAsync, clubId: club.id),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteClub(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Eliminar Organización'),
        content: Text('¿Estás seguro de eliminar "${club.nombreEntidad}"? Esta acción borrará sedes y categorías vinculadas.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCELAR')),
          TextButton(
            onPressed: () async {
              await ref.read(catalogRepositoryProvider).deleteEntidad(club.id);
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

class _SedesTab extends ConsumerWidget {
  final AsyncValue<List<Sede>> sedesAsync;
  final String clubId;
  const _SedesTab({required this.sedesAsync, required this.clubId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: sedesAsync.when(
        data: (sedes) => sedes.isEmpty 
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.location_off_outlined, size: 64, color: Colors.black12),
                  SizedBox(height: 16),
                  Text('No hay sedes registradas', style: TextStyle(color: Colors.black26, fontWeight: FontWeight.bold)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: sedes.length,
              itemBuilder: (context, i) => _buildSedeCard(context, ref, sedes[i]),
            ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, __) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'add_sede_$clubId',
        onPressed: () => _showAddSedeDialog(context, ref),
        backgroundColor: AppColors.gold,
        child: const Icon(Icons.add_location_alt, color: Colors.black),
      ),
    );
  }

  Widget _buildSedeCard(BuildContext context, WidgetRef ref, Sede sede) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        onTap: () => _showSedeDetail(context, ref, sede),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.1), shape: BoxShape.circle),
          child: const Icon(Icons.stadium_outlined, color: AppColors.gold, size: 20),
        ),
        title: Text(sede.nombreSede, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: AppColors.pitchPrimary)),
        subtitle: Text(sede.direccion ?? 'Sin dirección', style: const TextStyle(fontSize: 11, color: Colors.black38)),
        trailing: const Icon(Icons.chevron_right, color: Colors.black12),
      ),
    );
  }

  void _showAddSedeDialog(BuildContext context, WidgetRef ref, {Sede? sede}) {
    final nameCtrl = TextEditingController(text: sede?.nombreSede);
    final addrCtrl = TextEditingController(text: sede?.direccion);
    final capCtrl = TextEditingController(text: sede?.capacidad?.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        title: Text(sede == null ? 'Nueva Sede' : 'Editar Sede', 
          style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.pitchPrimary, fontSize: 20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nombre de la Sede')),
            const SizedBox(height: 16),
            TextField(controller: addrCtrl, decoration: const InputDecoration(labelText: 'Dirección')),
            const SizedBox(height: 16),
            TextField(controller: capCtrl, decoration: const InputDecoration(labelText: 'Capacidad'), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: const Text('CANCELAR', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black38))
          ),
          ElevatedButton(
            onPressed: () async {
              final data = {
                'entidad': clubId,
                'nombre_sede': nameCtrl.text,
                'direccion': addrCtrl.text,
                'capacidad': int.tryParse(capCtrl.text),
              };
              if (sede == null) {
                await ref.read(catalogRepositoryProvider).createSede(data);
              } else {
                await ref.read(catalogRepositoryProvider).updateSede(sede.id, data);
              }
              ref.invalidate(clubSedesProvider(clubId));
              if (context.mounted) Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.pitchPrimary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              minimumSize: const Size(100, 45)
            ),
            child: Text(sede == null ? 'CREAR' : 'GUARDAR'),
          ),
        ],
      ),
    );
  }

  void _showSedeDetail(BuildContext context, WidgetRef ref, Sede sede) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.stadium, color: AppColors.gold, size: 28),
                const SizedBox(width: 12),
                Expanded(child: Text(sede.nombreSede.toUpperCase(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.pitchPrimary))),
              ],
            ),
            const SizedBox(height: 24),
            _buildDetailRow(Icons.map_outlined, 'DIRECCIÓN', sede.direccion ?? "N/A"),
            const SizedBox(height: 16),
            _buildDetailRow(Icons.groups_outlined, 'CAPACIDAD', '${sede.capacidad ?? 0} Espectadores'),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _showAddSedeDialog(context, ref, sede: sede);
                    },
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: const Text('EDITAR'),
                    style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await ref.read(catalogRepositoryProvider).deleteSede(sede.id);
                      ref.invalidate(clubSedesProvider(clubId));
                      if (context.mounted) Navigator.pop(context);
                    },
                    icon: const Icon(Icons.delete_outline, size: 18),
                    label: const Text('BORRAR'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error.withOpacity(0.1),
                      foregroundColor: AppColors.error,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.black12),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.black26)),
            Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
          ],
        ),
      ],
    );
  }
}

class _CategoriasTab extends ConsumerWidget {
  final AsyncValue<List<Categoria>> categoriasAsync;
  final String clubId;
  const _CategoriasTab({required this.categoriasAsync, required this.clubId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: categoriasAsync.when(
        data: (cats) => cats.isEmpty 
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.group_off_outlined, size: 64, color: Colors.black12),
                  SizedBox(height: 16),
                  Text('No hay categorías registradas', style: TextStyle(color: Colors.black26, fontWeight: FontWeight.bold)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: cats.length,
              itemBuilder: (context, i) => _buildCategoryCard(context, ref, cats[i]),
            ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, __) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'add_cat_$clubId',
        onPressed: () => _showAddCategoryDialog(context, ref),
        backgroundColor: AppColors.gold,
        child: const Icon(Icons.group_add_outlined, color: Colors.black),
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, WidgetRef ref, Categoria cat) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        onTap: () => _showCategoryDetail(context, ref, cat),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: AppColors.pitchPrimary.withOpacity(0.05), shape: BoxShape.circle),
          child: const Icon(Icons.groups_outlined, color: AppColors.pitchPrimary, size: 20),
        ),
        title: Text(cat.nombre.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: AppColors.pitchPrimary)),
        subtitle: Text('Rango: ${cat.edadMinima}-${cat.edadMaxima} años', style: const TextStyle(fontSize: 11, color: Colors.black38)),
        trailing: const Icon(Icons.chevron_right, color: Colors.black12),
      ),
    );
  }

  void _showAddCategoryDialog(BuildContext context, WidgetRef ref, {Categoria? cat}) {
    final nameCtrl = TextEditingController(text: cat?.nombre);
    final minCtrl = TextEditingController(text: cat?.edadMinima?.toString());
    final maxCtrl = TextEditingController(text: cat?.edadMaxima?.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        title: Text(cat == null ? 'Nueva Categoría' : 'Editar Categoría', 
          style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.pitchPrimary, fontSize: 20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nombre (ej: Sub-17)')),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: TextField(controller: minCtrl, decoration: const InputDecoration(labelText: 'Edad Mín'), keyboardType: TextInputType.number)),
                const SizedBox(width: 16),
                Expanded(child: TextField(controller: maxCtrl, decoration: const InputDecoration(labelText: 'Edad Máx'), keyboardType: TextInputType.number)),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: const Text('CANCELAR', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black38))
          ),
          ElevatedButton(
            onPressed: () async {
              final data = {
                'entidad': clubId,
                'nombre': nameCtrl.text,
                'edad_minima': int.tryParse(minCtrl.text),
                'edad_maxima': int.tryParse(maxCtrl.text),
                'activo': true,
              };
              if (cat == null) {
                await ref.read(catalogRepositoryProvider).createCategoria(data);
              } else {
                await ref.read(catalogRepositoryProvider).updateCategoria(cat.id, data);
              }
              ref.invalidate(clubCategoriasProvider(clubId));
              if (context.mounted) Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.pitchPrimary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              minimumSize: const Size(100, 45)
            ),
            child: Text(cat == null ? 'CREAR' : 'GUARDAR'),
          ),
        ],
      ),
    );
  }

  void _showCategoryDetail(BuildContext context, WidgetRef ref, Categoria cat) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.group_work, color: AppColors.pitchPrimary, size: 28),
                const SizedBox(width: 12),
                Expanded(child: Text(cat.nombre.toUpperCase(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.pitchPrimary))),
              ],
            ),
            const SizedBox(height: 24),
            _buildDetailRow(Icons.cake_outlined, 'RANGO DE EDAD', '${cat.edadMinima} a ${cat.edadMaxima} años'),
            const SizedBox(height: 16),
            _buildDetailRow(Icons.check_circle_outline, 'ESTADO', cat.activo ? "ACTIVA" : "INACTIVA"),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _showAddCategoryDialog(context, ref, cat: cat);
                    },
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: const Text('EDITAR'),
                    style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await ref.read(catalogRepositoryProvider).deleteCategoria(cat.id);
                      ref.invalidate(clubCategoriasProvider(clubId));
                      if (context.mounted) Navigator.pop(context);
                    },
                    icon: const Icon(Icons.delete_outline, size: 18),
                    label: const Text('BORRAR'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error.withOpacity(0.1),
                      foregroundColor: AppColors.error,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.black12),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.black26)),
            Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
          ],
        ),
      ],
    );
  }
}

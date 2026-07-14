import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/model/entidad.dart';
import 'repository_providers.dart';

class BottomNavNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setIndex(int index) {
    state = index;
  }
}

final bottomNavProvider = NotifierProvider<BottomNavNotifier, int>(() => BottomNavNotifier());

class ActiveOrgNotifier extends Notifier<Entidad?> {
  @override
  Entidad? build() => null;
  void setOrg(Entidad org) => state = org;
}

final activeOrgProvider = NotifierProvider<ActiveOrgNotifier, Entidad?>(() => ActiveOrgNotifier());

// Provider GLOBAL para obtener los IDs de las categorías del club seleccionado
final activeCategoryIdsProvider = FutureProvider<List<String>>((ref) async {
  final activeOrg = ref.watch(activeOrgProvider);
  if (activeOrg == null) return [];
  final cats = await ref.read(catalogRepositoryProvider).getCategorias(entidadId: activeOrg.id);
  return cats.map((c) => c.id).toList();
});

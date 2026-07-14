import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/premium_gate.dart';
import '../../../theme/app_colors.dart';
import '../../providers/repository_providers.dart';
import '../../providers/ui_provider.dart';
import '../../providers/subscription_provider.dart';
import '../players/players_screen.dart';
import '../../../domain/model/lesion_registro.dart';
import '../../../domain/model/test_rendimiento.dart';
import '../../../domain/model/antecedentes_salud.dart';
import '../../../domain/model/historial_antropometrico.dart';
import 'lesion_detail_screen.dart';
import 'test_detail_screen.dart';
import 'bio_detail_screen.dart';
import 'medical_record_detail_screen.dart';

final allLesionsProvider = FutureProvider<List<LesionRegistro>>((ref) async {
  final all = await ref.read(healthRepositoryProvider).getAllLesiones();
  final activeOrg = ref.watch(activeOrgProvider);
  final isPremium = ref.watch(subscriptionProvider).isPremium;
  if (isPremium && activeOrg != null) {
    final players = await ref.read(playersProvider.future);
    final playerIds = players.map((p) => p.id).toList();
    return all.where((l) => playerIds.contains(l.jugadorId)).toList();
  }
  return all;
});

final allTestsProvider = FutureProvider<List<TestRendimiento>>((ref) async {
  final all = await ref.read(healthRepositoryProvider).getAllTests();
  final activeOrg = ref.watch(activeOrgProvider);
  final isPremium = ref.watch(subscriptionProvider).isPremium;
  if (isPremium && activeOrg != null) {
    final players = await ref.read(playersProvider.future);
    final playerIds = players.map((p) => p.id).toList();
    return all.where((t) => playerIds.contains(t.jugadorId)).toList();
  }
  return all;
});

final allAntecedentesProvider = FutureProvider<List<AntecedentesSalud>>((ref) async {
  final all = await ref.read(healthRepositoryProvider).getAllAntecedentes();
  final activeOrg = ref.watch(activeOrgProvider);
  final isPremium = ref.watch(subscriptionProvider).isPremium;
  if (isPremium && activeOrg != null) {
    final players = await ref.read(playersProvider.future);
    final playerIds = players.map((p) => p.id).toList();
    return all.where((a) => playerIds.contains(a.jugadorId)).toList();
  }
  return all;
});

final allBioProvider = FutureProvider<List<HistorialAntropometrico>>((ref) async {
  final all = await ref.read(healthRepositoryProvider).getAllAntropometria();
  final activeOrg = ref.watch(activeOrgProvider);
  final isPremium = ref.watch(subscriptionProvider).isPremium;
  if (isPremium && activeOrg != null) {
    final players = await ref.read(playersProvider.future);
    final playerIds = players.map((p) => p.id).toList();
    return all.where((b) => playerIds.contains(b.jugadorId)).toList();
  }
  return all;
});

class HealthScreen extends ConsumerWidget {
  const HealthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerMap = ref.watch(playersMapProvider).value ?? {};

    return PremiumGate(
      featureName: 'Módulo de Salud',
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Salud y Rendimiento'),
            bottom: const TabBar(
              isScrollable: true,
              indicatorColor: AppColors.gold,
              labelColor: Colors.white, // Color de la pestaña seleccionada
              unselectedLabelColor: Colors.white60, // Color de la pestaña no seleccionada
              labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 11),
              tabs: [
                Tab(text: 'LESIONES'),
                Tab(text: 'TESTS'),
                Tab(text: 'BIO'),
                Tab(text: 'FICHA MÉDICA'),
              ]
            ),
          ),
          body: TabBarView(
            children: [
              _LesionList(async: ref.watch(allLesionsProvider), playerMap: playerMap),
              _TestList(async: ref.watch(allTestsProvider), playerMap: playerMap),
              _BioList(async: ref.watch(allBioProvider), playerMap: playerMap),
              _HealthList(async: ref.watch(allAntecedentesProvider), playerMap: playerMap),
            ],
          ),
        ),
      ),
    );
  }
}

class _LesionList extends StatelessWidget {
  final AsyncValue<List<LesionRegistro>> async;
  final Map<String, String> playerMap;
  const _LesionList({required this.async, required this.playerMap});
  @override
  Widget build(BuildContext context) => async.when(
    data: (items) => ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: items.length,
      itemBuilder: (context, i) => Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LesionDetailScreen(lesion: items[i]))),
          leading: const Icon(Icons.medical_services, color: AppColors.error),
          title: Text(items[i].descripcion),
          subtitle: Text('Jugador: ${playerMap[items[i].jugadorId] ?? "Cargando..."}\nFecha: ${items[i].fechaInicio.toString().substring(0,10)}'),
          isThreeLine: true,
        ),
      ),
    ),
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (e, __) => Center(child: Text('Error: $e')),
  );
}

class _TestList extends StatelessWidget {
  final AsyncValue<List<TestRendimiento>> async;
  final Map<String, String> playerMap;
  const _TestList({required this.async, required this.playerMap});
  @override
  Widget build(BuildContext context) => async.when(
    data: (items) => ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: items.length,
      itemBuilder: (context, i) => Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TestDetailScreen(test: items[i]))),
          leading: const Icon(Icons.speed, color: AppColors.success),
          title: Text('Test - ${playerMap[items[i].jugadorId] ?? "Desconocido"}'),
          subtitle: Text('Fecha: ${items[i].fechaTest.toString().substring(0,10)}\nVel 30m: ${items[i].velocidad30mSeg}s'),
          isThreeLine: true,
        ),
      ),
    ),
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (e, __) => Center(child: Text('Error: $e')),
  );
}

class _BioList extends StatelessWidget {
  final AsyncValue<List<HistorialAntropometrico>> async;
  final Map<String, String> playerMap;
  const _BioList({required this.async, required this.playerMap});
  @override
  Widget build(BuildContext context) => async.when(
    data: (items) => ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: items.length,
      itemBuilder: (context, i) => Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BioDetailScreen(bio: items[i]))),
          leading: const Icon(Icons.straighten, color: Colors.purple),
          title: Text('Bio - ${playerMap[items[i].jugadorId] ?? "Desconocido"}'),
          subtitle: Text('Peso: ${items[i].pesoKg}Kg | IMC: ${items[i].imc?.toStringAsFixed(1) ?? "N/A"}'),
        ),
      ),
    ),
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (e, __) => Center(child: Text('Error: $e')),
  );
}

class _HealthList extends StatelessWidget {
  final AsyncValue<List<AntecedentesSalud>> async;
  final Map<String, String> playerMap;
  const _HealthList({required this.async, required this.playerMap});
  @override
  Widget build(BuildContext context) => async.when(
    data: (items) => ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: items.length,
      itemBuilder: (context, i) => Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MedicalRecordDetailScreen(record: items[i]))),
          leading: const Icon(Icons.health_and_safety, color: Colors.blue),
          title: Text('Salud - ${playerMap[items[i].jugadorId] ?? "Desconocido"}'),
          subtitle: Text('Sangre: ${items[i].tipoSangre ?? "N/A"}\nAlergias: ${items[i].alergias ?? "Ninguna"}'),
          isThreeLine: true,
        ),
      ),
    ),
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (e, __) => Center(child: Text('Error: $e')),
  );
}

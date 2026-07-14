import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/remote/api/dio_client.dart';
import '../../data/local/secure_storage.dart';
import '../../data/remote/interceptor/auth_interceptor.dart';
import '../../data/repository/auth_repository_impl.dart';
import '../../data/repository/catalog_repository_impl.dart';
import '../../data/repository/competition_repository_impl.dart';
import '../../data/repository/scouting_repository_impl.dart';
import '../../data/repository/health_repository_impl.dart';
import '../../domain/repository/auth_repository.dart';
import '../../domain/repository/catalog_repository.dart';
import '../../domain/repository/competition_repository.dart';
import '../../domain/repository/scouting_repository.dart';
import '../../domain/repository/health_repository.dart';

import '../../data/repository/player_repository_impl.dart';
import '../../domain/repository/player_repository.dart';

import '../../data/repository/subscription_repository_impl.dart';
import '../../domain/repository/subscription_repository.dart';

final secureStorageProvider = Provider((ref) => SecureStorage());

final dioProvider = Provider((ref) {
  final dioClient = DioClient();
  final storage = ref.watch(secureStorageProvider);
  dioClient.dio.interceptors.add(AuthInterceptor(storage));
  return dioClient.dio;
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.watch(dioProvider), ref.watch(secureStorageProvider));
});

final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  return CatalogRepositoryImpl(ref.watch(dioProvider));
});

final competitionRepositoryProvider = Provider<CompetitionRepository>((ref) {
  return CompetitionRepositoryImpl(ref.watch(dioProvider));
});

final scoutingRepositoryProvider = Provider<ScoutingRepository>((ref) {
  return ScoutingRepositoryImpl(ref.watch(dioProvider));
});

final healthRepositoryProvider = Provider<HealthRepository>((ref) {
  return HealthRepositoryImpl(ref.watch(dioProvider));
});

final playerRepositoryProvider = Provider<PlayerRepository>((ref) {
  return PlayerRepositoryImpl(ref.watch(dioProvider));
});

final playersMapProvider = FutureProvider<Map<String, String>>((ref) async {
  final players = await ref.read(playerRepositoryProvider).getJugadores();
  return {for (var p in players) p.id: p.nombreCompleto};
});

final subscriptionRepositoryProvider = Provider<SubscriptionRepository>((ref) {
  return SubscriptionRepositoryImpl(ref.watch(dioProvider));
});

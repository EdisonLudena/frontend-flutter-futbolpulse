import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/profile_screen.dart';
import '../screens/main_screen.dart';
import '../screens/subscription/subscription_plans_screen.dart';
import '../screens/subscription/checkout_screen.dart';
import '../screens/subscription/payment_success_screen.dart';
import '../screens/competition/create_match_screen.dart';
import '../screens/competition/match_detail_screen.dart';
import '../screens/competition/evaluation_detail_screen.dart';
import '../screens/competition/create_evaluation_screen.dart';
import '../screens/players/players_screen.dart';
import '../screens/players/create_player_screen.dart';
import '../screens/players/player_detail_screen.dart';
import '../screens/health/health_screen.dart';
import '../screens/health/lesion_detail_screen.dart';
import '../screens/health/test_detail_screen.dart';
import '../screens/competition/live_match_tracker_screen.dart';
import '../screens/scouting/prospect_detail_screen.dart';
import '../screens/scouting/report_detail_screen.dart';
import '../../domain/model/partido.dart';
import '../../domain/model/evaluacion_post_partido.dart';
import '../../domain/model/jugador.dart';
import '../../domain/model/lesion_registro.dart';
import '../../domain/model/test_rendimiento.dart';
import '../../domain/model/prospecto_seguimiento.dart';
import '../../domain/model/reporte_scouting.dart';

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: CircularProgressIndicator()));
}

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: _AuthRefreshListenable(ref),
    redirect: (context, state) {
      final status = authState.status;
      final location = state.matchedLocation;

      if (status == AuthStatus.checking) {
        return location == '/splash' ? null : '/splash';
      }

      final isAuthRoute = location == '/login' || location == '/register';
      if (status == AuthStatus.unauthenticated && !isAuthRoute) {
        return '/login';
      }

      if (status == AuthStatus.authenticated && (isAuthRoute || location == '/splash')) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(path: '/splash', builder: (_, __) => const _SplashScreen()),
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),
      GoRoute(path: '/', builder: (_, __) => const MainScreen()),
      GoRoute(path: '/subscription-plans', builder: (_, __) => const SubscriptionPlansScreen()),
      GoRoute(path: '/checkout', builder: (_, __) => const CheckoutScreen()),
      GoRoute(path: '/payment-success', builder: (_, __) => const PaymentSuccessScreen()),
      GoRoute(path: '/create-match', builder: (_, __) => const CreateMatchScreen()),
      GoRoute(path: '/create-evaluation', builder: (_, __) => const CreateEvaluationScreen()),
      GoRoute(path: '/create-player', builder: (_, __) => const CreatePlayerScreen()),
      GoRoute(path: '/profile', builder: (context, state) => const ProfileScreen()),
      GoRoute(path: '/health', builder: (context, state) => HealthScreen()),
      GoRoute(path: '/live-tracker', builder: (context, state) => LiveMatchTrackerScreen(partido: state.extra as Partido)),
      
      // Rutas de Detalle
      GoRoute(
        path: '/match-detail',
        builder: (context, state) => MatchDetailScreen(partido: state.extra as Partido),
      ),
      GoRoute(
        path: '/player-detail',
        builder: (context, state) => PlayerDetailScreen(jugador: state.extra as Jugador),
      ),
      GoRoute(
        path: '/prospect-detail',
        builder: (context, state) => ProspectDetailScreen(prospecto: state.extra as ProspectoSeguimiento),
      ),
      GoRoute(
        path: '/report-detail',
        builder: (context, state) => ReportDetailScreen(reporte: state.extra as ReporteScouting),
      ),
      GoRoute(
        path: '/lesion-detail',
        builder: (context, state) => LesionDetailScreen(lesion: state.extra as LesionRegistro),
      ),
      GoRoute(
        path: '/test-detail',
        builder: (context, state) => TestDetailScreen(test: state.extra as TestRendimiento),
      ),
      GoRoute(
        path: '/evaluation-detail',
        builder: (context, state) => EvaluationDetailScreen(evaluacion: state.extra as EvaluacionPostPartido),
      ),
    ],
  );
});

class _AuthRefreshListenable extends ChangeNotifier {
  _AuthRefreshListenable(Ref ref) {
    ref.listen(authProvider, (_, __) => notifyListeners());
  }
}

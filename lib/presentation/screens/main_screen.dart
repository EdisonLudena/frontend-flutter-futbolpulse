import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../providers/subscription_provider.dart';
import '../providers/ui_provider.dart';
import 'package:go_router/go_router.dart';

import 'auth/profile_screen.dart';
import 'competition/competition_screen.dart';
import 'dashboard/coach_dashboard_screen.dart';
import 'players/players_screen.dart';
import 'scouting/scouting_dashboard_screen.dart';
import 'scouting/scouting_reports_screen.dart';
import 'scouting/economic_valuation_screen.dart';
import 'health/health_screen.dart';
import '../../../theme/app_colors.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final isPremium = ref.watch(subscriptionProvider).isPremium;
    
    // Normalizamos el rol: Scout, Coach o Player (evitamos problemas de mayúsculas del backend)
    final String rawRole = user?.tipoUsuario ?? 'Coach';
    final String role = rawRole.trim().toLowerCase();
    
    final pages = _getPages(role, isPremium);
    int selectedIndex = ref.watch(bottomNavProvider);

    // Seguridad: Si el índice guardado es mayor que el número de pestañas actual, reseteamos a 0.
    // Esto ocurre al cambiar entre cuentas Premium/Básicas o cambiar de Rol.
    if (selectedIndex >= pages.length) {
      selectedIndex = 0;
      Future.microtask(() => ref.read(bottomNavProvider.notifier).setIndex(0));
    }

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hola, ${user?.nombreCompleto.split(' ').first ?? "Usuario"}', 
              style: const TextStyle(fontSize: 18, color: Colors.white)),
            Text(
              _getSubtitle(role, isPremium), 
              style: const TextStyle(
                color: Colors.white70, 
                fontSize: 10, 
                fontWeight: FontWeight.bold
              )
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: AppColors.chalk,
          image: DecorationImage(
            image: const NetworkImage('https://www.transparenttextures.com/patterns/cubes.png'),
            opacity: 0.03,
            repeat: ImageRepeat.repeat,
          ),
        ),
        child: IndexedStack(
          index: selectedIndex,
          children: pages,
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index) => ref.read(bottomNavProvider.notifier).setIndex(index),
          items: _getNavItems(role, isPremium),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.pitchPrimary,
          unselectedItemColor: Colors.black26,
          elevation: 0, // Quitamos la elevación nativa para usar nuestro Container con sombra personalizada
        ),
      ),
    );
  }

  String _getSubtitle(String role, bool isPremium) {
    if (role == 'scout') return 'SCOUT PROFESIONAL';
    if (isPremium) return 'PREMIUM ACTIVE';
    return 'PLAN BÁSICO';
  }

  List<BottomNavigationBarItem> _getNavItems(String role, bool isPremium) {
    if (role == 'scout') {
      return [
        const BottomNavigationBarItem(icon: Icon(Icons.person_search), label: 'Prospectos'),
        const BottomNavigationBarItem(icon: Icon(Icons.analytics_outlined), label: 'Reportes'),
        const BottomNavigationBarItem(icon: Icon(Icons.monetization_on_outlined), label: 'Mercado'),
        const BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Perfil'),
      ];
    }

    return [
      const BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), label: 'Inicio'),
      const BottomNavigationBarItem(icon: Icon(Icons.group_outlined), label: 'Plantilla'),
      const BottomNavigationBarItem(icon: Icon(Icons.sports_soccer), label: 'Competición'),
      if (isPremium) ...[
        const BottomNavigationBarItem(icon: Icon(Icons.person_search_outlined), label: 'Scouting'),
        const BottomNavigationBarItem(icon: Icon(Icons.health_and_safety_outlined), label: 'Salud'),
      ],
      const BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Perfil'),
    ];
  }

  List<Widget> _getPages(String role, bool isPremium) {
    if (role == 'scout') {
      return [
        const ScoutingDashboardScreen(), // Prospectos
        const ScoutingReportsScreen(),   // Reportes
        const EconomicValoracionScreen(),   // Mercado
        const ProfileScreen(),
      ];
    }

    return [
      const CoachDashboardScreen(),
      const PlayersScreen(),
      const CompetitionScreen(),
      if (isPremium) ...[
        const ScoutingDashboardScreen(),
        const HealthScreen(),
      ],
      const ProfileScreen(),
    ];
  }
}

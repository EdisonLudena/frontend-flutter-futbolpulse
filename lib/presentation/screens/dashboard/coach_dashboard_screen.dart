import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../providers/ui_provider.dart';
import '../../providers/subscription_provider.dart';
import '../../providers/repository_providers.dart';
import '../competition/matches_screen.dart';
import '../organization/club_management_screen.dart';
import '../../../core/utils/formatters.dart';
import '../subscription/plans_screen.dart';

class CoachDashboardScreen extends ConsumerWidget {
  const CoachDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matchesAsync = ref.watch(matchesProvider);
    final activeOrg = ref.watch(activeOrgProvider);
    final isPremium = ref.watch(subscriptionProvider).isPremium;
    final allClubsAsync = ref.watch(entidadesProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: isPremium 
          ? allClubsAsync.when(
              data: (clubs) {
                if (clubs.isEmpty) return Text('MI EQUIPO', style: AppTextStyles.scoreboard(size: 20));
                if (activeOrg == null) {
                  Future.microtask(() => ref.read(activeOrgProvider.notifier).setOrg(clubs.first));
                }
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.pitchPrimary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.gold.withOpacity(0.2)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: activeOrg?.id,
                      dropdownColor: Colors.white,
                      isDense: true,
                      style: const TextStyle(
                        color: AppColors.pitchPrimary, 
                        fontWeight: FontWeight.w900, 
                        fontSize: 15, 
                        fontFamily: 'Montserrat',
                        letterSpacing: 0.5
                      ),
                      icon: const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Icon(Icons.unfold_more_rounded, color: AppColors.gold, size: 20),
                      ),
                      onChanged: (id) {
                        final selected = clubs.firstWhere((c) => c.id == id);
                        ref.read(activeOrgProvider.notifier).setOrg(selected);
                        ref.invalidate(matchesProvider);
                      },
                      items: clubs.map((c) => DropdownMenuItem(
                        value: c.id,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.shield_outlined, size: 16, color: AppColors.pitchPrimary),
                            const SizedBox(width: 8),
                            Text(c.nombreEntidad.toUpperCase()),
                          ],
                        ),
                      )).toList(),
                    ),
                  ),
                );
              },
              loading: () => const Text('...'),
              error: (_, __) => const Text('Error'),
            )
          : Text('DASHBOARD', style: AppTextStyles.scoreboard(size: 20)),
      ),
      body: matchesAsync.when(
        data: (matches) {
          int victorias = matches.where((m) => m.estadoPartido == 'Finalizado' && m.golesFavor > m.golesContra).length;
          int derrotas = matches.where((m) => m.estadoPartido == 'Finalizado' && m.golesContra > m.golesFavor).length;
          int empates = matches.where((m) => m.estadoPartido == 'Finalizado' && m.golesFavor == m.golesContra).length;

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            children: [
              Text(
                'RESUMEN DE TEMPORADA',
                style: AppTextStyles.sectionTitle()
              ),
              const SizedBox(height: 16),
              // Grid de Estadísticas con Estilo Moderno
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.05,
                children: [
                  _StatCard(label: 'PARTIDOS', value: '${matches.length}', icon: Icons.sports_soccer, color: AppColors.pitchPrimary),
                  _StatCard(label: 'VICTORIAS', value: '$victorias', icon: Icons.emoji_events_outlined, color: AppColors.success),
                  _StatCard(label: 'DERROTAS', value: '$derrotas', icon: Icons.trending_down, color: AppColors.error),
                  _StatCard(label: 'EMPATES', value: '$empates', icon: Icons.drag_handle, color: Colors.blueGrey),
                ],
              ),
              
              if (matches.isNotEmpty) ...[
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('ÚLTIMOS RESULTADOS', style: AppTextStyles.sectionTitle()),
                    TextButton(
                      onPressed: () => ref.read(bottomNavProvider.notifier).setIndex(2),
                      child: const Text('VER TODO', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.gold)),
                    ),
                  ],
                ),
                ...matches.take(3).map((m) => _MatchResultCard(match: m)),
              ],
              
              const SizedBox(height: 32),
              Text('RENDIMIENTO GLOBAL', style: AppTextStyles.sectionTitle()),
              const SizedBox(height: 16),
              if (isPremium)
                _PerformanceCard(onTap: () => ref.read(bottomNavProvider.notifier).setIndex(4))
              else
                _PremiumUpgradeCard(
                  title: 'Análisis Físico Avanzado',
                  subtitle: 'Mide la evolución física de tus jugadores con tests y biometría.',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PlansScreen())),
                ),
              const SizedBox(height: 32),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, __) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label, value; final IconData icon; final Color color;
  const _StatCard({required this.label, required this.value, required this.icon, required this.color});
  
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(28),
      boxShadow: [
        BoxShadow(color: color.withOpacity(0.08), blurRadius: 24, offset: const Offset(0, 12)),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: Stack(
        children: [
          // Borde de acento izquierdo
          Positioned(
            left: 0, top: 0, bottom: 0,
            child: Container(width: 5, color: color.withOpacity(0.3)),
          ),
          
          // Marca de Agua
          Positioned(
            right: -10,
            bottom: -10,
            child: Icon(
              icon,
              size: 100,
              color: color.withOpacity(0.05),
            ),
          ),
          
          // Contenido
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color.withOpacity(0.15), color.withOpacity(0.05)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 18),
                ),
                const SizedBox(height: 12),
                Text(value, style: AppTextStyles.scoreboard(size: 34, color: color)),
                Text(
                  label, 
                  style: TextStyle(
                    fontSize: 9, 
                    fontWeight: FontWeight.w900, 
                    color: Colors.black.withOpacity(0.3), 
                    letterSpacing: 1
                  )
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _MatchResultCard extends StatelessWidget {
  final dynamic match;
  const _MatchResultCard({required this.match});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(match.rival.toUpperCase(), 
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: AppColors.pitchPrimary)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.pitchPrimary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text('${match.golesFavor} - ${match.golesContra}', 
              style: AppTextStyles.scoreboard(size: 18)),
          ),
        ],
      ),
    );
  }
}

class _PerformanceCard extends StatelessWidget {
  final VoidCallback onTap;
  const _PerformanceCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.pitchPrimary, Color(0xFF2D6A4F)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: AppColors.pitchPrimary.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('ESTADO DE FORMA PLANTILLA', 
                  style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 1)),
                Text('92%', style: AppTextStyles.scoreboard(size: 24, color: AppColors.goldLight)),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: 0.92, 
                backgroundColor: Colors.white10, 
                color: AppColors.goldLight,
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 12),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.insights, color: Colors.white54, size: 14),
                SizedBox(width: 8),
                Text('VER MÉTRICAS DE SALUD Y TESTS', 
                  style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PremiumUpgradeCard extends StatelessWidget {
  final String title, subtitle; final VoidCallback onTap;
  const _PremiumUpgradeCard({required this.title, required this.subtitle, required this.onTap});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: AppColors.gold.withOpacity(0.1)),
      boxShadow: [BoxShadow(color: AppColors.gold.withOpacity(0.05), blurRadius: 20)],
    ),
    child: Column(
      children: [
        const Icon(Icons.stars_rounded, color: AppColors.gold, size: 40),
        const SizedBox(height: 16),
        Text(title.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: AppColors.pitchPrimary)),
        const SizedBox(height: 8),
        Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black38, fontSize: 12)),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: onTap, 
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.gold, 
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('DESBLOQUEAR PREMIUM')
        ),
      ],
    ),
  );
}

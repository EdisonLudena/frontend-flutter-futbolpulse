import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../providers/subscription_provider.dart';
import '../../../theme/app_colors.dart';
import '../organization/club_management_screen.dart';
import '../subscription/plans_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final subState = ref.watch(subscriptionProvider);
    final isPremium = subState.isPremium;
    
    // Normalización de rol para comparaciones seguras
    final String rawRole = user?.tipoUsuario ?? 'Coach';
    final String role = rawRole.trim().toLowerCase();
    
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.pitchPrimaryLight,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text(
              user?.nombreCompleto ?? 'Cargando...',
              style: textTheme.headlineMedium,
            ),
            Text(
              _getRoleText(role, isPremium),
              style: textTheme.bodyMedium?.copyWith(
                color: (isPremium || role == 'scout') ? AppColors.gold : Colors.white54,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            _ProfileInfoCard(
              icon: Icons.email_outlined,
              label: 'Correo Electrónico',
              value: user?.email ?? '',
            ),
            const SizedBox(height: 16),
            _ProfileInfoCard(
              icon: Icons.language_outlined,
              label: 'Idioma',
              value: user?.idioma.toUpperCase() ?? 'ES',
            ),
            
            // Sección específica según el Rol
            if (role == 'coach') ...[
              if (isPremium) ...[
                const SizedBox(height: 24),
                ListTile(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ClubManagementScreen())),
                  leading: const Icon(Icons.business_center_outlined, color: AppColors.gold),
                  title: const Text('Gestionar mis Clubes', style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text('Entidades, sedes y categorías'),
                  tileColor: AppColors.surfaceDark,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ] else ...[
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.gold),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.star_outline, color: AppColors.gold, size: 32),
                      const SizedBox(height: 12),
                      const Text('MEJORA TU EXPERIENCIA', style: TextStyle(fontWeight: FontWeight.bold)),
                      const Text('Obtén Scouting, Salud y Gestión Multi-equipo.', textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PlansScreen())),
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.gold, foregroundColor: Colors.black),
                        child: const Text('VER PLANES DISPONIBLES'),
                      ),
                    ],
                  ),
                ),
              ],
            ],

            if (role == 'scout') ...[
               const SizedBox(height: 24),
               const Text('MODO SCOUT ACTIVO', style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold, fontSize: 10)),
               const SizedBox(height: 8),
               const Text('Tienes acceso a herramientas de mercado y análisis de campo profesional.', 
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.white38)),
            ],
            
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () => ref.read(authProvider.notifier).logout(),
              icon: const Icon(Icons.logout),
              label: const Text('CERRAR SESIÓN'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getRoleText(String role, bool isPremium) {
    if (role == 'scout') return 'SCOUT PROFESIONAL';
    return isPremium ? 'COACH PREMIUM' : 'COACH BÁSICO';
  }
}

class _ProfileInfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ProfileInfoCard({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lineDark),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.gold, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.bodySmall),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

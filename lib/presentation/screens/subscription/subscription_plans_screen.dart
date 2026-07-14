import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/app_colors.dart';

class SubscriptionPlansScreen extends StatelessWidget {
  const SubscriptionPlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Planes')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'ELIGE TU NIVEL',
              style: textTheme.displayMedium?.copyWith(color: AppColors.gold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            
            // Card Plan Básico
            _PlanCard(
              title: 'BÁSICO',
              price: 'Gratis',
              features: const [
                'Gestión de 1 Equipo',
                'Hasta 20 Jugadores',
                'Registro de Partidos',
                'Alineaciones Básicas',
              ],
              isPremium: false,
              onTap: () => context.pop(),
            ),
            
            const SizedBox(height: 24),
            
            // Card Plan Premium
            _PlanCard(
              title: 'PREMIUM',
              price: '\$9.99 / mes',
              features: const [
                'Equipos Ilimitados',
                'Módulo de Scouting Avanzado',
                'Seguimiento de Salud y Lesiones',
                'Valoración Económica de Jugadores',
                'Exportación de Reportes PDF',
              ],
              isPremium: true,
              onTap: () => context.push('/checkout'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final String title;
  final String price;
  final List<String> features;
  final bool isPremium;
  final VoidCallback onTap;

  const _PlanCard({
    required this.title,
    required this.price,
    required this.features,
    required this.isPremium,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isPremium ? AppColors.gold : AppColors.lineDark,
          width: isPremium ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            if (isPremium)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.gold,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text('RECOMENDADO', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 10)),
              ),
            const SizedBox(height: 12),
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(price, style: Theme.of(context).textTheme.displaySmall?.copyWith(color: isPremium ? AppColors.gold : null)),
            const SizedBox(height: 24),
            ...features.map((f) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: isPremium ? AppColors.gold : AppColors.success, size: 20),
                  const SizedBox(width: 12),
                  Expanded(child: Text(f)),
                ],
              ),
            )),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onTap,
              style: isPremium ? null : ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                side: const BorderSide(color: AppColors.lineDark),
              ),
              child: Text(isPremium ? 'MEJORAR AHORA' : 'PLAN ACTUAL'),
            ),
          ],
        ),
      ),
    );
  }
}

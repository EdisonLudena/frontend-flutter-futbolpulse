import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/subscription_provider.dart';
import '../../theme/app_colors.dart';

class PremiumGate extends ConsumerWidget {
  final Widget child;
  final String featureName;

  const PremiumGate({
    super.key,
    required this.child,
    this.featureName = 'esta función',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPremium = ref.watch(subscriptionProvider).isPremium;

    if (isPremium) return child;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_outline, size: 64, color: AppColors.gold),
            const SizedBox(height: 24),
            Text(
              'FUNCIÓN PREMIUM',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.gold,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              'Mejora tu plan para acceder a $featureName y llevar tu equipo al siguiente nivel.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => context.push('/subscription-plans'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gold,
                foregroundColor: Colors.black,
              ),
              child: const Text('VER PLANES'),
            ),
          ],
        ),
      ),
    );
  }
}

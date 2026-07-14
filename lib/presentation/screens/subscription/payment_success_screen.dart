import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/subscription_provider.dart';
import '../../../theme/app_colors.dart';

class PaymentSuccessScreen extends ConsumerWidget {
  const PaymentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Al entrar a esta pantalla, marcamos como Premium en el estado local
    // Nota: En una app real, esto se haría tras confirmar con el backend.
    Future.microtask(() => ref.read(subscriptionProvider.notifier).upgradeToPremiumLocally());

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle_outline, size: 100, color: AppColors.gold),
              const SizedBox(height: 32),
              Text(
                '¡PAGO EXITOSO!',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(color: AppColors.gold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Bienvenido a la experiencia Premium. Ahora tienes acceso ilimitado a todas las herramientas de análisis.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: () => context.go('/'),
                child: const Text('VOLVER AL INICIO'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

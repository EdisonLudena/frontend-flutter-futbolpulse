import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../theme/app_colors.dart';
import '../../providers/subscription_provider.dart';

class PlansScreen extends ConsumerWidget {
  const PlansScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Elige tu Plan')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text('Potencia tu gestión deportiva', 
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            const Text('Lleva tu equipo al siguiente nivel con herramientas Pro.', 
                textAlign: TextAlign.center, style: TextStyle(color: Colors.white54)),
            const SizedBox(height: 32),
            
            // PLAN GRATUITO
            _PlanCard(
              title: 'PLAN BÁSICO',
              price: 'GRATIS',
              color: Colors.white.withOpacity(0.05),
              features: const [
                'Gestión de 1 equipo',
                'Plantilla de jugadores',
                'Registro de partidos',
              ],
              buttonText: 'PLAN ACTUAL',
              isCurrent: true,
              onTap: () {},
            ),
            
            const SizedBox(height: 24),
            
            // PLAN PREMIUM
            _PlanCard(
              title: 'PREMIUM PRO',
              price: '\$9.99 / mes',
              color: AppColors.gold.withOpacity(0.1),
              borderColor: AppColors.gold,
              features: const [
                'Gestión Multi-equipo',
                'Módulo de Salud Completo',
                'Seguimiento de Scouting',
                'Análisis Físico Avanzado',
                'Rastreo en Vivo y Cronología',
              ],
              buttonText: 'CONTRATAR AHORA',
              onTap: () => _showPaymentForm(context, ref),
            ),
          ],
        ),
      ),
    );
  }

  void _showPaymentForm(BuildContext context, WidgetRef ref) {
    final cardCtrl = TextEditingController();
    final dateCtrl = TextEditingController();
    final cvvCtrl = TextEditingController();
    final nameCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceDark,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 24, right: 24, top: 32
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.lock_outline, color: AppColors.gold, size: 20),
                SizedBox(width: 8),
                Text('PAGO SEGURO SSL', style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Detalles de la Tarjeta', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Nombre en la tarjeta', prefixIcon: Icon(Icons.person_outline)),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: cardCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Número de tarjeta', prefixIcon: Icon(Icons.credit_card)),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: dateCtrl,
                    decoration: const InputDecoration(labelText: 'MM/AA', hintText: '12/28'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: cvvCtrl,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'CVV', hintText: '***'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                // Simulación de procesamiento
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const Center(child: CircularProgressIndicator(color: AppColors.gold)),
                );
                
                await Future.delayed(const Duration(seconds: 2));
                
                if (context.mounted) {
                  ref.read(subscriptionProvider.notifier).upgradeToPremiumLocally();
                  Navigator.pop(context); // Cierra loading
                  Navigator.pop(context); // Cierra bottom sheet
                  Navigator.pop(context); // Vuelve al dashboard
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('¡Pago procesado con éxito! Ahora eres Premium.'),
                      backgroundColor: AppColors.success,
                    )
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gold,
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
              ),
              child: const Text('CONFIRMAR Y PAGAR \$9.99', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final String title, price, buttonText;
  final List<String> features;
  final Color color;
  final Color? borderColor;
  final bool isCurrent;
  final VoidCallback onTap;

  const _PlanCard({
    required this.title, required this.price, required this.features, 
    required this.color, this.borderColor, this.isCurrent = false, 
    required this.buttonText, required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        border: borderColor != null ? Border.all(color: borderColor!, width: 2) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2, color: AppColors.gold)),
              if (isCurrent)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(8)),
                  child: const Text('ACTUAL', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(price, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          const Divider(height: 40, color: Colors.white10),
          ...features.map((f) => Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Row(
              children: [
                const Icon(Icons.check_circle, size: 18, color: AppColors.gold),
                const SizedBox(width: 12),
                Expanded(child: Text(f, style: const TextStyle(fontSize: 14))),
              ],
            ),
          )),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: isCurrent ? null : onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: isCurrent ? Colors.white.withOpacity(0.05) : AppColors.gold,
              foregroundColor: isCurrent ? Colors.white24 : Colors.black,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: isCurrent ? 0 : 4,
            ),
            child: Text(buttonText, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

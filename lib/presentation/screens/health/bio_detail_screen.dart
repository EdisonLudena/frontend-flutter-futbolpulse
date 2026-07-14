import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/model/historial_antropometrico.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../providers/repository_providers.dart';
import 'health_screen.dart';

class BioDetailScreen extends ConsumerWidget {
  final HistorialAntropometrico bio;
  const BioDetailScreen({super.key, required this.bio});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerMap = ref.watch(playersMapProvider).value ?? {};
    final playerName = playerMap[bio.jugadorId] ?? 'Cargando...';

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Análisis Biométrico'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _confirmDelete(context, ref),
          ),
        ],
      ),
      body: Column(
        children: [
          // Header con Gradiente y Peso Destacado
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 120, 24, 40),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Color(0xFF34495E), Color(0xFF2C3E50)], // Azul grisáceo muy profesional
              ),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
            ),
            child: Column(
              children: [
                Text(playerName.toUpperCase(), 
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTopStat('PESO', '${bio.pesoKg}', 'KG'),
                    const SizedBox(width: 40),
                    _buildTopStat('ALTURA', '${bio.alturaCm}', 'CM'),
                  ],
                ),
              ],
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Tarjeta de Composición Corporal
                  _buildCompositionCard(),
                  const SizedBox(height: 20),
                  // Tarjeta de IMC
                  _buildIMCCard(),
                  const SizedBox(height: 20),
                  if (bio.observaciones != null && bio.observaciones!.isNotEmpty)
                    _buildObservationCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopStat(String label, String value, String unit) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(value, style: AppTextStyles.scoreboard(size: 36, color: Colors.white)),
            const SizedBox(width: 4),
            Text(unit, style: const TextStyle(color: AppColors.gold, fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  Widget _buildCompositionCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('COMPOSICIÓN CORPORAL', style: AppTextStyles.sectionTitle()),
          const SizedBox(height: 20),
          _buildBioRow('Grasa Corporal', '${bio.grasaCorporal ?? "N/A"} %', Icons.pie_chart_outline),
          const Divider(height: 32, color: Color(0xFFF1F3F5)),
          _buildBioRow('Masa Muscular', '${bio.masaMuscular ?? "N/A"} Kg', Icons.fitness_center),
        ],
      ),
    );
  }

  Widget _buildIMCCard() {
    final imc = bio.imc ?? 0.0;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppColors.pitchPrimary.withOpacity(0.02), AppColors.pitchPrimary.withOpacity(0.05)]),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.pitchPrimary.withOpacity(0.05)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('IMC (ÍNDICE MASA CORP.)', style: AppTextStyles.sectionTitle()),
              const SizedBox(height: 4),
              const Text('Categoría: Saludable', style: TextStyle(fontSize: 12, color: AppColors.success, fontWeight: FontWeight.bold)),
            ],
          ),
          Text(imc.toStringAsFixed(1), style: AppTextStyles.scoreboard(size: 32)),
        ],
      ),
    );
  }

  Widget _buildBioRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.pitchPrimary.withOpacity(0.3)),
        const SizedBox(width: 12),
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w500)),
        const Spacer(),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.pitchPrimary)),
      ],
    );
  }

  Widget _buildObservationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('NOTAS TÉCNICAS', style: AppTextStyles.sectionTitle()),
          const SizedBox(height: 12),
          Text(bio.observaciones!, style: const TextStyle(fontSize: 14, color: Colors.black54, height: 1.5)),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('¿Eliminar Registro?'),
        content: const Text('Se borrará permanentemente la toma biométrica del historial.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCELAR')),
          TextButton(
            onPressed: () async {
              // await ref.read(healthRepositoryProvider).deleteAntropometria(bio.id);
              ref.invalidate(allBioProvider);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('ELIMINAR', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

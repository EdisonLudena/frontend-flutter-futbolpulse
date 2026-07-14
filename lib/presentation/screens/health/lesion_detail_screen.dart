import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/model/lesion_registro.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../providers/repository_providers.dart';
import '../players/players_screen.dart';
import 'health_screen.dart';

class LesionDetailScreen extends ConsumerWidget {
  final LesionRegistro lesion;
  const LesionDetailScreen({super.key, required this.lesion});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerMap = ref.watch(playersMapProvider).value ?? {};
    final playerName = playerMap[lesion.jugadorId] ?? 'Cargando...';

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Ficha Médica'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _confirmDelete(context, ref),
          ),
        ],
      ),
      body: Column(
        children: [
          // Header con Gradiente y Avatar
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 120, 24, 40),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.pitchPrimary, AppColors.pitchPrimaryLight],
              ),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 16),
                Text(playerName.toUpperCase(), 
                  style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: lesion.activa ? AppColors.error : AppColors.success,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    lesion.activa ? "LESIONADO" : "RECUPERADO",
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailCard(
                    icon: Icons.description_outlined,
                    title: 'Descripción de la Lesión',
                    content: lesion.descripcion,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(child: _buildInfoBox('Zona', lesion.zonaCuerpo, Icons.accessibility_new)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildInfoBox('Gravedad', lesion.gravedad ?? 'N/A', Icons.warning_amber_rounded)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildDateSection(lesion),
                  const SizedBox(height: 40),
                  if (lesion.activa)
                    ElevatedButton(
                      onPressed: () => _marcarComoRecuperado(context, ref),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        minimumSize: const Size(double.infinity, 60),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle_outline),
                          SizedBox(width: 12),
                          Text('FINALIZAR RECUPERACIÓN', style: TextStyle(letterSpacing: 1.2)),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard({required IconData icon, required String title, required String content}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.pitchPrimary, size: 20),
              const SizedBox(width: 8),
              Text(title, style: AppTextStyles.sectionTitle()),
            ],
          ),
          const SizedBox(height: 12),
          Text(content, style: const TextStyle(fontSize: 16, height: 1.4, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildInfoBox(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.pitchPrimary.withOpacity(0.5)),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.black38, fontWeight: FontWeight.bold)),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildDateSection(LesionRegistro lesion) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.pitchPrimary.withOpacity(0.03),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildDateColumn('Inicio', lesion.fechaInicio),
          const Icon(Icons.arrow_forward_rounded, color: Colors.black12),
          _buildDateColumn('Alta', lesion.fechaAlta ?? DateTime.now(), isPlaceholder: lesion.fechaAlta == null),
        ],
      ),
    );
  }

  Widget _buildDateColumn(String label, DateTime date, {bool isPlaceholder = false}) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black38)),
        const SizedBox(height: 4),
        Text(
          isPlaceholder ? '--/--/--' : date.toString().substring(0, 10),
          style: TextStyle(
            fontSize: 14, 
            fontWeight: FontWeight.w900, 
            color: isPlaceholder ? Colors.black12 : AppColors.pitchPrimary
          ),
        ),
      ],
    );
  }

  Future<void> _marcarComoRecuperado(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(healthRepositoryProvider).saveLesion({
        'id': lesion.id,
        'activa': false,
        'fecha_alta': DateTime.now().toIso8601String().substring(0, 10),
      });
      await ref.read(playerRepositoryProvider).updateJugador(lesion.jugadorId, {'estado': 'Activo'});
      ref.invalidate(allLesionsProvider);
      ref.invalidate(playersProvider);
      if (context.mounted) Navigator.pop(context);
    } catch (_) {}
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('¿Eliminar Registro?'),
        content: const Text('Esta acción es permanente y no se podrá recuperar el historial médico.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCELAR')),
          TextButton(
            onPressed: () async {
              await ref.read(healthRepositoryProvider).deleteLesion(lesion.id);
              ref.invalidate(allLesionsProvider);
              if (context.mounted) {
                Navigator.pop(context);
                Navigator.pop(context);
              }
            },
            child: const Text('ELIMINAR', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/model/prospecto_seguimiento.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../providers/repository_providers.dart';
import 'scouting_dashboard_screen.dart';
import 'create_prospect_screen.dart';

class ProspectDetailScreen extends ConsumerWidget {
  final ProspectoSeguimiento prospecto;
  const ProspectDetailScreen({super.key, required this.prospecto});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CreateProspectScreen(prospectoParaEditar: prospecto))),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.white70),
            onPressed: () => _confirmDelete(context, ref),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  _buildStatusCard(),
                  const SizedBox(height: 20),
                  _buildObservationCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 110, 24, 40),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.pitchPrimary, Color(0xFF2D6A4F)],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 45,
            backgroundColor: Colors.white12,
            child: Icon(Icons.person_search, size: 50, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Text(
            prospecto.nombreJugador?.toUpperCase() ?? 'SIN NOMBRE',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 1.5),
          ),
          const SizedBox(height: 4),
          Text(
            prospecto.equipoActual?.toUpperCase() ?? 'AGENTE LIBRE',
            style: const TextStyle(color: AppColors.goldLight, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildInfoItem('ESTADO', prospecto.estado.toUpperCase(), Icons.radar, AppColors.gold),
          Container(width: 1, height: 40, color: Colors.black12),
          _buildInfoItem('NACIONALIDAD', prospecto.nacionalidad?.toUpperCase() ?? 'N/A', Icons.flag_outlined, AppColors.pitchPrimary),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, size: 18, color: color.withOpacity(0.5)),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.black38)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.black87)),
      ],
    );
  }

  Widget _buildObservationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.notes, size: 18, color: AppColors.pitchPrimary),
              const SizedBox(width: 10),
              Text('OBSERVACIONES TÉCNICAS', style: AppTextStyles.sectionTitle()),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            prospecto.observaciones ?? 'No hay observaciones registradas para este prospecto.',
            style: const TextStyle(fontSize: 15, color: Colors.black54, height: 1.6),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('¿Eliminar Prospecto?'),
        content: const Text('Se perderá todo el seguimiento realizado hasta ahora.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCELAR')),
          TextButton(
            onPressed: () async {
              await ref.read(scoutingRepositoryProvider).deleteProspecto(prospecto.id);
              ref.invalidate(prospectosProvider);
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/model/antecedentes_salud.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../providers/repository_providers.dart';
import 'health_screen.dart';

class MedicalRecordDetailScreen extends ConsumerWidget {
  final AntecedentesSalud record;
  const MedicalRecordDetailScreen({super.key, required this.record});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerMap = ref.watch(playersMapProvider).value ?? {};
    final playerName = playerMap[record.jugadorId] ?? 'Cargando...';

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F2), // Fondo sutilmente más oscuro para resaltar fichas
      appBar: AppBar(
        title: const Text('Ficha Médica'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.error),
            onPressed: () => _confirmDelete(context, ref),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Resumen de Jugador
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20)],
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Color(0xFFE8F5E9),
                    child: Icon(Icons.health_and_safety, color: AppColors.pitchPrimary, size: 32),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(playerName.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                        const SizedBox(height: 4),
                        Text('SANGRE: ${record.tipoSangre ?? "N/A"}', 
                          style: const TextStyle(color: AppColors.error, fontWeight: FontWeight.bold, fontSize: 11)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            _buildInfoCard(
              title: 'ANTECEDENTES Y CONDICIONES',
              items: [
                _InfoRow(label: 'ALERGIAS', value: record.alergias ?? 'NINGUNA', icon: Icons.warning_amber),
                _InfoRow(label: 'MEDICAMENTOS', value: record.medicamentosRegulares ?? 'NINGUNO', icon: Icons.medication_liquid),
                _InfoRow(label: 'CRÓNICAS', value: record.condicionesCronicas ?? 'NINGUNA', icon: Icons.history_edu),
              ],
            ),
            
            const SizedBox(height: 24),
            
            _buildInfoCard(
              title: 'CONTACTO DE EMERGENCIA',
              items: [
                _InfoRow(label: 'NOMBRE', value: record.contactoMedicoNombre ?? 'S/N', icon: Icons.person_outline),
                _InfoRow(label: 'TELÉFONO', value: record.contactoMedicoTel ?? 'S/N', icon: Icons.phone_android),
              ],
            ),
            
            const SizedBox(height: 40),
            Text('ÚLTIMA ACTUALIZACIÓN: ${record.actualizadoEn.toString().substring(0, 10)}', 
              style: const TextStyle(color: Colors.black26, fontSize: 10, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({required String title, required List<Widget> items}) {
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
          Text(title, style: AppTextStyles.sectionTitle()),
          const SizedBox(height: 20),
          ...items,
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Eliminar Ficha?'),
        content: const Text('Se borrará todo el historial médico del jugador.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCELAR')),
          TextButton(
            onPressed: () async {
              ref.invalidate(allAntecedentesProvider);
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

class _InfoRow extends StatelessWidget {
  final String label, value;
  final IconData icon;
  const _InfoRow({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.black12),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 10, color: Colors.black38, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

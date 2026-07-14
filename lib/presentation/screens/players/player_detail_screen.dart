import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/model/jugador.dart';
import '../../../domain/model/valoracion_economica.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../providers/repository_providers.dart';
import '../../providers/subscription_provider.dart';
import 'players_screen.dart';
import 'create_player_screen.dart';
import '../health/health_screen.dart';
import '../scouting/economic_valuation_screen.dart';

class PlayerDetailScreen extends ConsumerWidget {
  final Jugador jugador;
  const PlayerDetailScreen({super.key, required this.jugador});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPremium = ref.watch(subscriptionProvider).isPremium;
    final valuationsMap = ref.watch(allValuationsProvider);
    
    if (isPremium && valuationsMap.isEmpty) {
      Future.microtask(() => ref.read(allValuationsProvider.notifier).load());
    }

    final playerValuations = valuationsMap[jugador.id] ?? [];
    final ValoracionEconomica? valuation = playerValuations.isNotEmpty ? playerValuations.first : null;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Perfil del Jugador'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CreatePlayerScreen(jugadorParaEditar: jugador),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _confirmDelete(context, ref),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 110, 24, 40),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Color(0xFF1E2E26), AppColors.pitchPrimary],
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white10,
                      child: Icon(Icons.person, size: 60, color: Colors.white),
                    ),
                    Positioned(
                      right: 0, bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(color: AppColors.gold, shape: BoxShape.circle),
                        child: Text('${jugador.numeroCamiseta ?? "?"}', 
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(jugador.nombreCompleto.toUpperCase(), 
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
                const SizedBox(height: 6),
                _buildPlayerStatusBadge(),
              ],
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('INFORMACIÓN TÉCNICA'),
                  const SizedBox(height: 12),
                  _buildTechnicalCard(),
                  
                  if (isPremium) ...[
                    const SizedBox(height: 24),
                    _buildSectionTitle('MÓDULOS DE GESTIÓN'),
                    const SizedBox(height: 12),
                    _buildModulesGrid(context, ref),
                    const SizedBox(height: 24),
                    _buildValuationCard(valuation),
                  ] else ...[
                    const SizedBox(height: 32),
                    _buildPremiumUpgradeLock(),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumUpgradeLock() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.gold.withOpacity(0.1)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 20)],
      ),
      child: const Column(
        children: [
          Icon(Icons.lock_outline, color: AppColors.gold, size: 32),
          SizedBox(height: 16),
          Text('FUNCIONES PREMIUM', style: TextStyle(fontWeight: FontWeight.w900, color: AppColors.pitchPrimary, letterSpacing: 1)),
          SizedBox(height: 8),
          Text('Suscríbete para acceder a la gestión de lesiones, salud, tests y valoración económica de tu plantilla.', 
            textAlign: TextAlign.center, 
            style: TextStyle(fontSize: 12, color: Colors.black38, height: 1.5)),
        ],
      ),
    );
  }

  Widget _buildPlayerStatusBadge() {
    final isLesionado = jugador.estado == 'Lesionado';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isLesionado ? AppColors.error : AppColors.success,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        jugador.estado.toUpperCase(),
        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: AppTextStyles.sectionTitle());
  }

  Widget _buildTechnicalCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTechStat('PIE', jugador.pieDominante.toUpperCase()),
          Container(width: 1, height: 30, color: Colors.black12),
          _buildTechStat('NAC.', (jugador.nacionalidad ?? "N/A").toUpperCase()),
        ],
      ),
    );
  }

  Widget _buildTechStat(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.black38, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.black87)),
      ],
    );
  }

  Widget _buildModulesGrid(BuildContext context, WidgetRef ref) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 2.2,
      children: [
        _buildModuleItem(Icons.medical_services, 'LESIÓN', AppColors.error, () => _showLesionDialog(context, ref)),
        _buildModuleItem(Icons.speed, 'TEST', AppColors.success, () => _showTestDialog(context, ref)),
        _buildModuleItem(Icons.health_and_safety, 'SALUD', Colors.blue, () => _showHealthDialog(context, ref)),
        _buildModuleItem(Icons.straighten, 'BIO', Colors.purple, () => _showBioDialog(context, ref)),
      ],
    );
  }

  Widget _buildModuleItem(IconData icon, String label, Color color, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.1)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 8),
              Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildValuationCard(ValoracionEconomica? valuation) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('VALORACIÓN ECONÓMICA'),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFFFFF9E6), Color(0xFFFEF3D1)]),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: AppColors.gold.withOpacity(0.2)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('VALOR DE MERCADO ACTUAL', style: AppTextStyles.sectionTitle(color: AppColors.gold)),
                  const SizedBox(height: 4),
                  Text(
                    valuation != null ? '\$${valuation.valorEstimado.toStringAsFixed(0)} ${valuation.moneda}' : 'TASACIÓN PENDIENTE',
                    style: TextStyle(
                      fontSize: valuation != null ? 22 : 14, 
                      fontWeight: FontWeight.w900, 
                      color: AppColors.pitchPrimary
                    ),
                  ),
                ],
              ),
              const Icon(Icons.trending_up, color: AppColors.gold, size: 32),
            ],
          ),
        ),
      ],
    );
  }

  void _showLesionDialog(BuildContext context, WidgetRef ref) {
    final descCtrl = TextEditingController();
    final zonaCtrl = TextEditingController();
    String gravedad = 'Leve';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('REGISTRAR LESIÓN', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.error)),
            const SizedBox(height: 20),
            TextField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Descripción')),
            const SizedBox(height: 16),
            TextField(controller: zonaCtrl, decoration: const InputDecoration(labelText: 'Zona del Cuerpo')),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: gravedad,
              items: ['Leve', 'Moderada', 'Grave'].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
              onChanged: (v) => gravedad = v!,
              decoration: const InputDecoration(labelText: 'Gravedad'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                try {
                  await ref.read(healthRepositoryProvider).saveLesion({
                    'jugador': jugador.id,
                    'descripcion': descCtrl.text,
                    'zona_cuerpo': zonaCtrl.text,
                    'gravedad': gravedad,
                    'fecha_inicio': DateTime.now().toIso8601String().substring(0, 10),
                    'activa': true,
                  });
                  await ref.read(playerRepositoryProvider).updateJugador(jugador.id, {'estado': 'Lesionado'});
                  ref.invalidate(allLesionsProvider);
                  ref.invalidate(playersProvider);
                  if (context.mounted) Navigator.pop(context);
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.error)
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, minimumSize: const Size(double.infinity, 50)),
              child: const Text('GUARDAR LESIÓN'),
            ),
          ],
        ),
      ),
    );
  }

  void _showTestDialog(BuildContext context, WidgetRef ref) {
    final vel30Ctrl = TextEditingController();
    final vel60Ctrl = TextEditingController();
    final saltoVCtrl = TextEditingController();
    final saltoHCtrl = TextEditingController();
    final vo2Ctrl = TextEditingController();
    final resNivelCtrl = TextEditingController();
    final flexCtrl = TextEditingController();
    final agilidadCtrl = TextEditingController();
    final obsCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('NUEVO TEST DE RENDIMIENTO', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.success)),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: TextField(controller: vel30Ctrl, decoration: const InputDecoration(labelText: 'Vel. 30m (s)'), keyboardType: TextInputType.number)),
                  const SizedBox(width: 16),
                  Expanded(child: TextField(controller: vel60Ctrl, decoration: const InputDecoration(labelText: 'Vel. 60m (s)'), keyboardType: TextInputType.number)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: TextField(controller: saltoVCtrl, decoration: const InputDecoration(labelText: 'Salto Vert. (cm)'), keyboardType: TextInputType.number)),
                  const SizedBox(width: 16),
                  Expanded(child: TextField(controller: saltoHCtrl, decoration: const InputDecoration(labelText: 'Salto Horiz. (cm)'), keyboardType: TextInputType.number)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: TextField(controller: vo2Ctrl, decoration: const InputDecoration(labelText: 'VO2 Max (ml)'), keyboardType: TextInputType.number)),
                  const SizedBox(width: 16),
                  Expanded(child: TextField(controller: resNivelCtrl, decoration: const InputDecoration(labelText: 'Nivel Resistencia'), keyboardType: TextInputType.number)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: TextField(controller: flexCtrl, decoration: const InputDecoration(labelText: 'Flexib. (cm)'), keyboardType: TextInputType.number)),
                  const SizedBox(width: 16),
                  Expanded(child: TextField(controller: agilidadCtrl, decoration: const InputDecoration(labelText: 'Agilidad (s)'), keyboardType: TextInputType.number)),
                ],
              ),
              const SizedBox(height: 16),
              TextField(controller: obsCtrl, decoration: const InputDecoration(labelText: 'Observaciones del Test'), maxLines: 2),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await ref.read(healthRepositoryProvider).saveTestRendimiento({
                      'jugador': jugador.id,
                      'velocidad_30m_seg': double.tryParse(vel30Ctrl.text),
                      'velocidad_60m_seg': double.tryParse(vel60Ctrl.text),
                      'salto_vertical_cm': int.tryParse(saltoVCtrl.text),
                      'salto_horizontal_cm': int.tryParse(saltoHCtrl.text),
                      'resistencia_vo2max': double.tryParse(vo2Ctrl.text),
                      'resistencia_nivel': int.tryParse(resNivelCtrl.text),
                      'flexibilidad_cm': int.tryParse(flexCtrl.text),
                      'agilidad_seg': double.tryParse(agilidadCtrl.text),
                      'observaciones': obsCtrl.text,
                      'fecha_test': DateTime.now().toIso8601String().substring(0, 10),
                    });
                    ref.invalidate(allTestsProvider);
                    if (context.mounted) Navigator.pop(context);
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.error)
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.success, minimumSize: const Size(double.infinity, 50)),
                child: const Text('GUARDAR RESULTADOS'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showHealthDialog(BuildContext context, WidgetRef ref) {
    String? sangre = 'O+';
    final alergiasCtrl = TextEditingController();
    final medicCtrl = TextEditingController();
    final cronicasCtrl = TextEditingController();
    final contactNomCtrl = TextEditingController();
    final contactTelCtrl = TextEditingController();

    final List<String> tiposSangre = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('FICHA MÉDICA / SALUD', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: sangre,
                  decoration: const InputDecoration(labelText: 'Tipo de Sangre'),
                  items: tiposSangre.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                  onChanged: (v) => setModalState(() => sangre = v),
                ),
                const SizedBox(height: 12),
                TextField(controller: alergiasCtrl, decoration: const InputDecoration(labelText: 'Alergias'), maxLines: 2),
                const SizedBox(height: 12),
                TextField(controller: medicCtrl, decoration: const InputDecoration(labelText: 'Medicamentos'), maxLines: 2),
                const SizedBox(height: 12),
                TextField(controller: cronicasCtrl, decoration: const InputDecoration(labelText: 'Condiciones Crónicas'), maxLines: 2),
                const SizedBox(height: 20),
                const Text('CONTACTO DE EMERGENCIA', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black38)),
                const SizedBox(height: 8),
                TextField(controller: contactNomCtrl, decoration: const InputDecoration(labelText: 'Nombre Contacto')),
                const SizedBox(height: 8),
                TextField(controller: contactTelCtrl, decoration: const InputDecoration(labelText: 'Teléfono Contacto'), keyboardType: TextInputType.phone),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await ref.read(healthRepositoryProvider).saveAntecedentes({
                        'jugador': jugador.id,
                        'tipo_sangre': sangre,
                        'alergias': alergiasCtrl.text,
                        'medicamentos_regulares': medicCtrl.text,
                        'condiciones_cronicas': cronicasCtrl.text,
                        'contacto_medico_nombre': contactNomCtrl.text,
                        'contacto_medico_tel': contactTelCtrl.text,
                      });
                      ref.invalidate(allAntecedentesProvider);
                      if (context.mounted) Navigator.pop(context);
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.error)
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, minimumSize: const Size(double.infinity, 50)),
                  child: const Text('ACTUALIZAR FICHA'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showBioDialog(BuildContext context, WidgetRef ref) {
    final pesoCtrl = TextEditingController();
    final alturaCtrl = TextEditingController();
    final grasaCtrl = TextEditingController();
    final masaCtrl = TextEditingController();
    final notasCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('ANTROPOMETRÍA / BIO', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple)),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: TextField(controller: pesoCtrl, decoration: const InputDecoration(labelText: 'Peso (kg)'), keyboardType: TextInputType.number)),
                  const SizedBox(width: 16),
                  Expanded(child: TextField(controller: alturaCtrl, decoration: const InputDecoration(labelText: 'Altura (cm)'), keyboardType: TextInputType.number)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: TextField(controller: grasaCtrl, decoration: const InputDecoration(labelText: '% Grasa Corporal'), keyboardType: TextInputType.number)),
                  const SizedBox(width: 16),
                  Expanded(child: TextField(controller: masaCtrl, decoration: const InputDecoration(labelText: 'Masa Muscular (kg)'), keyboardType: TextInputType.number)),
                ],
              ),
              const SizedBox(height: 16),
              TextField(controller: notasCtrl, decoration: const InputDecoration(labelText: 'Notas Técnicas'), maxLines: 2),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  try {
                    // Validar altura para evitar error 500 por IMC fuera de rango numérico (precision 5,2)
                    final double? peso = double.tryParse(pesoCtrl.text);
                    final double? altura = double.tryParse(alturaCtrl.text);
                    if (altura != null && altura < 50) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Por favor ingresa una altura válida (min 50cm)'), backgroundColor: AppColors.warning)
                      );
                      return;
                    }

                    await ref.read(healthRepositoryProvider).saveAntropometria({
                      'jugador': jugador.id,
                      'peso_kg': peso,
                      'altura_cm': altura,
                      'grasa_corporal': double.tryParse(grasaCtrl.text),
                      'masa_muscular': double.tryParse(masaCtrl.text),
                      'observaciones': notasCtrl.text,
                      'fecha_toma': DateTime.now().toIso8601String().substring(0, 10),
                    });
                    ref.invalidate(allBioProvider);
                    if (context.mounted) Navigator.pop(context);
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.error)
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, minimumSize: const Size(double.infinity, 50)),
                child: const Text('GUARDAR TOMA'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('¿Eliminar Jugador?'),
        content: const Text('Esta acción borrará al jugador de la plantilla y todos sus registros históricos.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCELAR')),
          TextButton(
            onPressed: () async {
              await ref.read(playerRepositoryProvider).deleteJugador(jugador.id);
              ref.invalidate(playersProvider);
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

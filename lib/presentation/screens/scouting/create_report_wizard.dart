import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../providers/scouting_report_provider.dart';
import '../../providers/repository_providers.dart';
import 'scouting_dashboard_screen.dart';
import 'scouting_reports_screen.dart';

class CreateReportWizard extends ConsumerStatefulWidget {
  const CreateReportWizard({super.key});

  @override
  ConsumerState<CreateReportWizard> createState() => _CreateReportWizardState();
}

class _CreateReportWizardState extends ConsumerState<CreateReportWizard> {
  final PageController _pageController = PageController();

  // Step 1 Controllers
  String? _selectedProspectId;
  final _partidoCtrl = TextEditingController();
  final _comentarioCtrl = TextEditingController();
  int _stars = 3;

  // Step 2: Métricas Técnicas (0-100)
  final Map<String, int> _techMetrics = {
    'control': 50,
    'pase_corto': 50,
    'pase_largo': 50,
    'tiro': 50,
    'regate': 50,
    'cabeceo': 50,
    'velocidad': 50,
    'resistencia': 50,
  };

  // Step 3: Métricas Tácticas (0-100)
  final Map<String, int> _tacticalMetrics = {
    'ubicacion': 50,
    'lectura_juego': 50,
    'sacrificio': 50,
    'liderazgo': 50,
    'presion': 50,
    'trabajo_equipo': 50,
  };

  @override
  void dispose() {
    _pageController.dispose();
    _partidoCtrl.dispose();
    _comentarioCtrl.dispose();
    super.dispose();
  }

  void _nextStep() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(scoutingReportProvider);
    final notifier = ref.read(scoutingReportProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Nuevo Informe Técnico'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            notifier.reset();
            context.pop();
          },
        ),
      ),
      body: Column(
        children: [
          _StepIndicator(currentStep: state.currentStep),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildStep1(state, notifier),
                _buildStep2(state, notifier),
                _buildStep3(state, notifier),
                _buildSuccessStep(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep1(ScoutingReportState state, ScoutingReportNotifier notifier) {
    final prospectosAsync = ref.watch(prospectosProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('1. INFORMACIÓN GENERAL', style: AppTextStyles.sectionTitle()),
          const SizedBox(height: 20),
          
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                prospectosAsync.when(
                  data: (list) => DropdownButtonFormField<String>(
                    value: _selectedProspectId,
                    decoration: const InputDecoration(labelText: 'SELECCIONAR PROSPECTO', prefixIcon: Icon(Icons.person_search_outlined)),
                    items: list.map((p) => DropdownMenuItem(value: p.id, child: Text(p.nombreJugador ?? 'S/N'))).toList(),
                    onChanged: (v) => setState(() => _selectedProspectId = v),
                  ),
                  loading: () => const LinearProgressIndicator(),
                  error: (e, _) => const Text('Error al cargar prospectos'),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _partidoCtrl,
                  decoration: const InputDecoration(labelText: 'PARTIDO OBSERVADO', hintText: 'Ej: Sub-17 vs Ind. del Valle', prefixIcon: Icon(Icons.sports_soccer)),
                ),
                const SizedBox(height: 24),
                const Text('VALORACIÓN GLOBAL', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black38)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (i) => IconButton(
                    iconSize: 32,
                    icon: Icon(i < _stars ? Icons.star : Icons.star_border, color: AppColors.gold),
                    onPressed: () => setState(() => _stars = i + 1),
                  )),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _comentarioCtrl,
                  maxLines: 4,
                  decoration: const InputDecoration(labelText: 'COMENTARIOS INICIALES', alignLabelWithHint: true),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          if (state.error != null) 
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(state.error!, style: const TextStyle(color: AppColors.error, fontSize: 12)),
            ),
          
          ElevatedButton(
            onPressed: state.isLoading || _selectedProspectId == null
              ? null
              : () async {
                  final success = await notifier.createBaseReport({
                    'prospecto': _selectedProspectId,
                    'jugador': null,
                    'partido_observado': _partidoCtrl.text,
                    'valoracion_estrellas': _stars,
                    'comentario_tecnico': _comentarioCtrl.text,
                  });
                  if (success) _nextStep();
                },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 60),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            child: state.isLoading 
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text('SIGUIENTE: MÉTRICAS TÉCNICAS'),
          ),
        ],
      ),
    );
  }

  Widget _buildStep2(ScoutingReportState state, ScoutingReportNotifier notifier) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('2. RENDIMIENTO TÉCNICO', style: AppTextStyles.sectionTitle()),
          const SizedBox(height: 20),
          
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20)],
            ),
            child: Column(
              children: _techMetrics.keys.map((key) => _MetricSlider(
                label: key.replaceAll('_', ' ').toUpperCase(),
                value: _techMetrics[key]!.toDouble(),
                onChanged: (v) => setState(() => _techMetrics[key] = v.toInt()),
              )).toList(),
            ),
          ),
          
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: state.isLoading
              ? null
              : () async {
                  final success = await notifier.saveTechMetrics({
                    'control': _techMetrics['control'],
                    'pase_corto': _techMetrics['pase_corto'],
                    'pase_largo': _techMetrics['pase_largo'],
                    'tiro': _techMetrics['tiro'],
                    'regate': _techMetrics['regate'],
                    'cabeceo': _techMetrics['cabeceo'],
                    'velocidad': _techMetrics['velocidad'],
                    'resistencia': _techMetrics['resistencia'],
                  });
                  if (success) _nextStep();
                },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 60),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            child: state.isLoading 
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text('SIGUIENTE: ANÁLISIS TÁCTICO'),
          ),
        ],
      ),
    );
  }

  Widget _buildStep3(ScoutingReportState state, ScoutingReportNotifier notifier) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('3. ANÁLISIS TÁCTICO', style: AppTextStyles.sectionTitle()),
          const SizedBox(height: 20),
          
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20)],
            ),
            child: Column(
              children: _tacticalMetrics.keys.map((key) => _MetricSlider(
                label: key.replaceAll('_', ' ').toUpperCase(),
                value: _tacticalMetrics[key]!.toDouble(),
                onChanged: (v) => setState(() => _tacticalMetrics[key] = v.toInt()),
              )).toList(),
            ),
          ),
          
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: state.isLoading
              ? null
              : () async {
                  final success = await notifier.saveTacticalMetrics({
                    'ubicacion': _tacticalMetrics['ubicacion'],
                    'lectura_juego': _tacticalMetrics['lectura_juego'],
                    'sacrificio': _tacticalMetrics['sacrificio'],
                    'liderazgo': _tacticalMetrics['liderazgo'],
                    'presion': _tacticalMetrics['presion'],
                    'trabajo_equipo': _tacticalMetrics['trabajo_equipo'],
                  });
                  if (success) _nextStep();
                },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 60),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            child: state.isLoading 
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text('FINALIZAR INFORME TÉCNICO'),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessStep() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle_outline, size: 100, color: AppColors.success),
          const SizedBox(height: 32),
          Text('¡INFORME COMPLETADO!', style: AppTextStyles.scoreboard(size: 28)),
          const SizedBox(height: 16),
          const Text(
            'Los datos técnicos y tácticos han sido procesados y guardados exitosamente en la base de datos central.', 
            textAlign: TextAlign.center, 
            style: TextStyle(color: Colors.black45, fontSize: 14, height: 1.5)
          ),
          const SizedBox(height: 48),
          ElevatedButton(
            onPressed: () {
              ref.read(scoutingReportProvider.notifier).reset();
              ref.invalidate(scoutingReportsProvider);
              context.pop();
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 60),
              backgroundColor: AppColors.pitchPrimary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            child: const Text('VOLVER AL DASHBOARD'),
          ),
        ],
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final int currentStep;
  const _StepIndicator({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
      color: Colors.white,
      child: Row(
        children: List.generate(3, (index) {
          final isActive = index <= currentStep;
          final isCompleted = index < currentStep;
          final isLast = index == 2;
          return Expanded(
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 28, height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive ? AppColors.pitchPrimary : AppColors.chalk,
                    border: Border.all(color: isActive ? AppColors.pitchPrimary : Colors.black12),
                  ),
                  child: Center(
                    child: isCompleted 
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : Text('${index + 1}', 
                          style: TextStyle(color: isActive ? Colors.white : Colors.black26, fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ),
                if (!isLast) 
                  Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 3,
                      color: isActive ? AppColors.pitchPrimary : AppColors.chalk,
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _MetricSlider extends StatelessWidget {
  final String label;
  final double value;
  final ValueChanged<double> onChanged;

  const _MetricSlider({required this.label, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 10, color: Colors.black45, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
            Text('${value.toInt()}%', style: const TextStyle(color: AppColors.pitchPrimary, fontWeight: FontWeight.w900)),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 2,
            activeTrackColor: AppColors.gold,
            inactiveTrackColor: AppColors.chalk,
            thumbColor: AppColors.gold,
            overlayColor: AppColors.gold.withOpacity(0.1),
            valueIndicatorColor: AppColors.pitchPrimary,
          ),
          child: Slider(
            value: value,
            min: 0, max: 100,
            onChanged: onChanged,
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

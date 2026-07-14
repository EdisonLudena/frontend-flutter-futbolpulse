import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/model/reporte_scouting.dart';
import 'repository_providers.dart';

class ScoutingReportState {
  final int currentStep;
  final ReporteScouting? reporte;
  final bool isLoading;
  final String? error;

  ScoutingReportState({
    this.currentStep = 0,
    this.reporte,
    this.isLoading = false,
    this.error,
  });

  ScoutingReportState copyWith({
    int? currentStep,
    ReporteScouting? reporte,
    bool? isLoading,
    String? error,
  }) {
    return ScoutingReportState(
      currentStep: currentStep ?? this.currentStep,
      reporte: reporte ?? this.reporte,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class ScoutingReportNotifier extends Notifier<ScoutingReportState> {
  @override
  ScoutingReportState build() {
    return ScoutingReportState();
  }

  void setStep(int step) => state = state.copyWith(currentStep: step);

  Future<bool> createBaseReport(Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final repo = await ref.read(scoutingRepositoryProvider).createReporte(data);
      state = state.copyWith(reporte: repo, currentStep: 1, isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> saveTechMetrics(Map<String, dynamic> data) async {
    if (state.reporte == null) return false;
    state = state.copyWith(isLoading: true, error: null);
    try {
      final payload = {
        'reporte': state.reporte!.id,
        'control': data['control'],
        'pase_corto': data['pase_corto'],
        'pase_largo': data['pase_largo'],
        'tiro': data['tiro'],
        'regate': data['regate'],
        'cabeceo': data['cabeceo'],
        'velocidad': data['velocidad'],
        'resistencia': data['resistencia'],
      };
      await ref.read(scoutingRepositoryProvider).saveMetricasTecnicas(payload);
      state = state.copyWith(currentStep: 2, isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> saveTacticalMetrics(Map<String, dynamic> data) async {
    if (state.reporte == null) return false;
    state = state.copyWith(isLoading: true, error: null);
    try {
      final payload = {
        'reporte': state.reporte!.id,
        'ubicacion': data['ubicacion'],
        'lectura_juego': data['lectura_juego'],
        'sacrificio': data['sacrificio'],
        'liderazgo': data['liderazgo'],
        'presion': data['presion'],
        'trabajo_equipo': data['trabajo_equipo'],
      };
      await ref.read(scoutingRepositoryProvider).saveMetricasTacticas(payload);
      state = state.copyWith(isLoading: false, currentStep: 3); 
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  void reset() => state = ScoutingReportState();
}

final scoutingReportProvider = NotifierProvider<ScoutingReportNotifier, ScoutingReportState>(() {
  return ScoutingReportNotifier();
});

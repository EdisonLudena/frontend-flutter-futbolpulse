import '../model/prospecto_seguimiento.dart';
import '../model/reporte_scouting.dart';
import '../model/valoracion_economica.dart';
import '../model/metrica_tecnica.dart';
import '../model/metrica_tactica.dart';

abstract class ScoutingRepository {
  Future<List<ProspectoSeguimiento>> getProspectos();
  Future<ProspectoSeguimiento> createProspecto(Map<String, dynamic> data);
  Future<ProspectoSeguimiento> updateProspecto(String id, Map<String, dynamic> data);
  Future<void> deleteProspecto(String id);
  
  Future<List<ReporteScouting>> getReportes();
  Future<ReporteScouting> createReporte(Map<String, dynamic> data);
  Future<ReporteScouting> updateReporte(String id, Map<String, dynamic> data);
  Future<void> deleteReporte(String id);
  
  Future<void> saveMetricasTecnicas(Map<String, dynamic> data);
  Future<void> saveMetricasTacticas(Map<String, dynamic> data);
  
  Future<MetricaTecnica?> getMetricasTecnicas(String reporteId);
  Future<MetricaTactica?> getMetricasTacticas(String reporteId);
  
  Future<List<ValoracionEconomica>> getValoraciones(String? jugadorId);
  Future<void> saveValoracion(Map<String, dynamic> data);
  Future<void> updateValoracion(String id, Map<String, dynamic> data);
}

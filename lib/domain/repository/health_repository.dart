import '../model/antecedentes_salud.dart';
import '../model/historial_antropometrico.dart';
import '../model/test_rendimiento.dart';

import '../model/lesion_registro.dart';
import '../model/sesion_rehabilitacion.dart';
import '../model/plan_alimenticio.dart';

abstract class HealthRepository {
  Future<List<AntecedentesSalud>> getAllAntecedentes();
  Future<AntecedentesSalud?> getAntecedentes(String jugadorId);
  Future<void> saveAntecedentes(Map<String, dynamic> data);

  Future<List<HistorialAntropometrico>> getAllAntropometria();
  Future<List<HistorialAntropometrico>> getHistorialAntropometrico(String jugadorId);
  Future<void> saveAntropometria(Map<String, dynamic> data);

  Future<List<TestRendimiento>> getAllTests();
  Future<List<TestRendimiento>> getTestsRendimiento(String jugadorId);
  Future<void> saveTestRendimiento(Map<String, dynamic> data);
  Future<void> deleteTestRendimiento(String id);

  Future<List<LesionRegistro>> getAllLesiones();
  Future<List<LesionRegistro>> getLesiones(String jugadorId);
  Future<void> saveLesion(Map<String, dynamic> data);
  Future<void> deleteLesion(String id);

  Future<List<SesionRehabilitacion>> getRehabilitacion(String lesionId);
  Future<void> saveRehabilitacion(Map<String, dynamic> data);

  Future<List<PlanAlimenticio>> getPlanesAlimenticios(String jugadorId);
  Future<void> savePlanAlimenticio(Map<String, dynamic> data);
}

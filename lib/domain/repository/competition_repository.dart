import '../model/partido.dart';
import '../model/alineacion.dart';
import '../model/evaluacion_post_partido.dart';
import '../model/jugador.dart';

abstract class CompetitionRepository {
  Future<List<Partido>> getPartidos({String? categoriaId});
  Future<Partido> getPartido(String id);
  Future<Partido> createPartido(Map<String, dynamic> data);
  Future<Partido> updatePartido(String id, Map<String, dynamic> data);
  Future<void> deletePartido(String id);
  
  Future<List<Alineacion>> getAlineaciones(String partidoId);
  Future<void> saveAlineacion(Map<String, dynamic> data);
  Future<void> deleteAlineacion(String id);
  
  Future<void> createEventoLive(Map<String, dynamic> data);
  Future<List<dynamic>> getEventosLive(String partidoId);
  
  Future<void> saveEvaluacion(Map<String, dynamic> data);
  Future<void> updateEvaluacion(String id, Map<String, dynamic> data);
  Future<void> deleteEvaluacion(String id);
  Future<List<EvaluacionPostPartido>> getEvaluaciones({String? jugadorId});
  Future<List<Jugador>> getJugadores();
}

import '../model/jugador.dart';
import '../model/jugador_posicion.dart';

abstract class PlayerRepository {
  Future<List<Jugador>> getJugadores();
  Future<Jugador> createJugador(Map<String, dynamic> data);
  Future<Jugador> updateJugador(String id, Map<String, dynamic> data);
  Future<void> deleteJugador(String id);

  Future<List<JugadorPosicion>> getPosicionesJugador(String jugadorId);
  Future<void> savePosicionJugador(Map<String, dynamic> data);
}

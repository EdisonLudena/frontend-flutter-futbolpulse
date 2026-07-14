import '../../../domain/model/alineacion.dart';

class AlineacionDto {
  final String id;
  final String? partido;
  final String? jugador;
  final bool esTitular;
  final String? posicionPartido;
  final int minutoEntrada;
  final int minutoSalida;
  final int minutosJugados;

  AlineacionDto({
    required this.id,
    this.partido,
    this.jugador,
    required this.esTitular,
    this.posicionPartido,
    required this.minutoEntrada,
    required this.minutoSalida,
    required this.minutosJugados,
  });

  factory AlineacionDto.fromJson(Map<String, dynamic> json) {
    return AlineacionDto(
      id: json['id'] as String,
      partido: json['partido'] as String?,
      jugador: json['jugador'] as String?,
      esTitular: json['es_titular'] as bool? ?? true,
      posicionPartido: json['posicion_partido'] as String?,
      minutoEntrada: (json['minuto_entrada'] as num?)?.toInt() ?? 0,
      minutoSalida: (json['minuto_salida'] as num?)?.toInt() ?? 90,
      minutosJugados: (json['minutos_jugados'] as num?)?.toInt() ?? 0,
    );
  }

  Alineacion toDomain() => Alineacion(
        id: id,
        partidoId: partido ?? '',
        jugadorId: jugador ?? '',
        esTitular: esTitular,
        posicionPartidoId: posicionPartido,
        minutoEntrada: minutoEntrada,
        minutoSalida: minutoSalida,
        minutosJugados: minutosJugados,
      );
}

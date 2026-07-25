import 'package:json_annotation/json_annotation.dart';
import '../../../domain/model/evaluacion_post_partido.dart';
import '../../../core/utils/parsers.dart';

part 'evaluacion_post_partido_dto.g.dart';

@JsonSerializable()
class EvaluacionPostPartidoDto {
  final String? id;
  
  // DRF puede enviar el ID directamente o el objeto expandido
  final dynamic partido; 
  @JsonKey(name: 'partido_id')
  final String? partidoId;
  
  final dynamic jugador;
  @JsonKey(name: 'jugador_id')
  final String? jugadorId;

  @JsonKey(fromJson: parseDecimal)
  final double? calificacion;
  @JsonKey(name: 'puntos_positivos')
  final String? puntosPositivos;
  @JsonKey(name: 'puntos_a_mejorar')
  final String? puntosAMejorar;
  @JsonKey(name: 'es_visible_jugador')
  final bool? esVisibleJugador;
  @JsonKey(name: 'creado_en')
  final String? creadoEn;

  EvaluacionPostPartidoDto({
    this.id,
    this.partido,
    this.partidoId,
    this.jugador,
    this.jugadorId,
    this.calificacion,
    this.puntosPositivos,
    this.puntosAMejorar,
    this.esVisibleJugador,
    this.creadoEn,
  });

  factory EvaluacionPostPartidoDto.fromJson(Map<String, dynamic> json) =>
      _$EvaluacionPostPartidoDtoFromJson(json);

  Map<String, dynamic> toJson() => _$EvaluacionPostPartidoDtoToJson(this);

  EvaluacionPostPartido toDomain() {
    // Extraer ID de Partido (sea String o Mapa)
    String pId = '';
    String? rival;
    if (partido is String) pId = partido;
    else if (partido is Map) {
      pId = partido['id'] ?? '';
      rival = "${partido['equipo_local'] ?? 'Local'} vs ${partido['equipo_visitante'] ?? 'Visitante'}";
    }
    if (pId.isEmpty) pId = partidoId ?? '';
    // Extraer ID de Jugador (sea String o Mapa)
    String jId = '';
    String? nombreJ;
    if (jugador is String) jId = jugador;
    else if (jugador is Map) {
      jId = jugador['id'] ?? '';
      nombreJ = "${jugador['nombres'] ?? ''} ${jugador['apellidos'] ?? ''}".trim();
    }
    if (jId.isEmpty) jId = jugadorId ?? '';

    return EvaluacionPostPartido(
      id: id ?? '',
      partidoId: pId,
      jugadorId: jId,
      calificacion: calificacion ?? 0.0,
      puntosPositivos: puntosPositivos,
      puntosAMejorar: puntosAMejorar,
      esVisibleJugador: esVisibleJugador ?? false,
      creadoEn: creadoEn != null ? DateTime.parse(creadoEn!) : DateTime.now(),
      nombreJugador: nombreJ,
      rivalPartido: rival,
    );
  }
}

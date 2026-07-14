// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'evaluacion_post_partido_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EvaluacionPostPartidoDto _$EvaluacionPostPartidoDtoFromJson(
  Map<String, dynamic> json,
) => EvaluacionPostPartidoDto(
  id: json['id'] as String?,
  partido: json['partido'],
  partidoId: json['partido_id'] as String?,
  jugador: json['jugador'],
  jugadorId: json['jugador_id'] as String?,
  calificacion: parseDecimal(json['calificacion']),
  puntosPositivos: json['puntos_positivos'] as String?,
  puntosAMejorar: json['puntos_a_mejorar'] as String?,
  esVisibleJugador: json['es_visible_jugador'] as bool?,
  creadoEn: json['creado_en'] as String?,
);

Map<String, dynamic> _$EvaluacionPostPartidoDtoToJson(
  EvaluacionPostPartidoDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'partido': instance.partido,
  'partido_id': instance.partidoId,
  'jugador': instance.jugador,
  'jugador_id': instance.jugadorId,
  'calificacion': instance.calificacion,
  'puntos_positivos': instance.puntosPositivos,
  'puntos_a_mejorar': instance.puntosAMejorar,
  'es_visible_jugador': instance.esVisibleJugador,
  'creado_en': instance.creadoEn,
};

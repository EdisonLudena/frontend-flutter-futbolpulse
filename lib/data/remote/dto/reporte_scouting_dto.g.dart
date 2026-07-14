// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reporte_scouting_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReporteScoutingDto _$ReporteScoutingDtoFromJson(Map<String, dynamic> json) =>
    ReporteScoutingDto(
      id: json['id'] as String?,
      usuarioId: json['usuario_id'] as String?,
      jugadorId: json['jugador_id'] as String?,
      prospectoId: json['prospecto_id'] as String?,
      valoracionEstrellas: (json['valoracion_estrellas'] as num?)?.toInt(),
      comentarioTecnico: json['comentario_tecnico'] as String?,
      partidoObservado: json['partido_observado'] as String?,
      fechaReporte: json['fecha_reporte'] as String?,
    );

Map<String, dynamic> _$ReporteScoutingDtoToJson(ReporteScoutingDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'usuario_id': instance.usuarioId,
      'jugador_id': instance.jugadorId,
      'prospecto_id': instance.prospectoId,
      'valoracion_estrellas': instance.valoracionEstrellas,
      'comentario_tecnico': instance.comentarioTecnico,
      'partido_observado': instance.partidoObservado,
      'fecha_reporte': instance.fechaReporte,
    };

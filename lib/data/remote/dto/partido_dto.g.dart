// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partido_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PartidoDto _$PartidoDtoFromJson(Map<String, dynamic> json) => PartidoDto(
  id: json['id'] as String?,
  equipoLocal: json['equipo_local'] as String?,
  equipoVisitante: json['equipo_visitante'] as String?,
  fecha: json['fecha'] as String?,
  tipoPartido: json['tipo_partido'] as String?,
  golesFavor: (json['goles_favor'] as num?)?.toInt(),
  golesContra: (json['goles_contra'] as num?)?.toInt(),
  resultadoFinal: json['resultado_final'] as String?,
  estadoPartido: json['estado_partido'] as String?,
  observaciones: json['observaciones'] as String?,
  categoria: json['categoria'] as String?,
  sede: json['sede'] as String?,
  entidad: json['entidad'] as String?,
);

Map<String, dynamic> _$PartidoDtoToJson(PartidoDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'equipo_local': instance.equipoLocal,
      'equipo_visitante': instance.equipoVisitante,
      'fecha': instance.fecha,
      'tipo_partido': instance.tipoPartido,
      'goles_favor': instance.golesFavor,
      'goles_contra': instance.golesContra,
      'resultado_final': instance.resultadoFinal,
      'estado_partido': instance.estadoPartido,
      'observaciones': instance.observaciones,
      'categoria': instance.categoria,
      'sede': instance.sede,
      'entidad': instance.entidad,
    };

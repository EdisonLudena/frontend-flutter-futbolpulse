// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partido_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PartidoDto _$PartidoDtoFromJson(Map<String, dynamic> json) => PartidoDto(
      id: json['id'] as String?,
      rival: json['rival'] as String?,
      esLocal: json['es_local'] as bool?,
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
      'rival': instance.rival,
      'es_local': instance.esLocal,
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

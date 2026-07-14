// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'evento_live_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventoLiveDto _$EventoLiveDtoFromJson(Map<String, dynamic> json) =>
    EventoLiveDto(
      id: json['id'] as String?,
      partido: json['partido'],
      partidoId: json['partido_id'] as String?,
      jugador: json['jugador'],
      jugadorId: json['jugador_id'] as String?,
      minuto: (json['minuto'] as num?)?.toInt(),
      tipoEvento: json['tipo_evento'] as String?,
      descripcion: json['descripcion'] as String?,
      creadoEn: json['creado_en'] as String?,
    );

Map<String, dynamic> _$EventoLiveDtoToJson(EventoLiveDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'partido': instance.partido,
      'partido_id': instance.partidoId,
      'jugador': instance.jugador,
      'jugador_id': instance.jugadorId,
      'minuto': instance.minuto,
      'tipo_evento': instance.tipoEvento,
      'descripcion': instance.descripcion,
      'creado_en': instance.creadoEn,
    };

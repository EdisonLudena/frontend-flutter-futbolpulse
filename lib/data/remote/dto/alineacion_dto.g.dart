// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alineacion_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlineacionDto _$AlineacionDtoFromJson(Map<String, dynamic> json) =>
    AlineacionDto(
      id: json['id'] as String,
      partidoId: json['partido_id'] as String,
      jugadorId: json['jugador_id'] as String,
      esTitular: json['es_titular'] as bool,
      posicionPartidoId: json['posicion_partido_id'] as String?,
      minutoEntrada: (json['minuto_entrada'] as num).toInt(),
      minutoSalida: (json['minuto_salida'] as num).toInt(),
      minutosJugados: (json['minutos_jugados'] as num).toInt(),
    );

Map<String, dynamic> _$AlineacionDtoToJson(AlineacionDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'partido_id': instance.partidoId,
      'jugador_id': instance.jugadorId,
      'es_titular': instance.esTitular,
      'posicion_partido_id': instance.posicionPartidoId,
      'minuto_entrada': instance.minutoEntrada,
      'minuto_salida': instance.minutoSalida,
      'minutos_jugados': instance.minutosJugados,
    };

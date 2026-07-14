// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jugador_posicion_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JugadorPosicionDto _$JugadorPosicionDtoFromJson(Map<String, dynamic> json) =>
    JugadorPosicionDto(
      id: (json['id'] as num?)?.toInt(),
      jugador: json['jugador'] as String?,
      posicion: json['posicion'] as String?,
      esPrincipal: json['es_principal'] as bool?,
      nombrePosicion: json['nombre_posicion'] as String?,
      abreviaturaPosicion: json['abreviatura_posicion'] as String?,
    );

Map<String, dynamic> _$JugadorPosicionDtoToJson(JugadorPosicionDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'jugador': instance.jugador,
      'posicion': instance.posicion,
      'es_principal': instance.esPrincipal,
      'nombre_posicion': instance.nombrePosicion,
      'abreviatura_posicion': instance.abreviaturaPosicion,
    };

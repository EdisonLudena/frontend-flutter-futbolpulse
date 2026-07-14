// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'posicion_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PosicionDto _$PosicionDtoFromJson(Map<String, dynamic> json) => PosicionDto(
  id: json['id'] as String?,
  nombrePosicion: json['nombre_posicion'] as String?,
  abreviatura: json['abreviatura'] as String?,
  zona: json['zona'] as String?,
);

Map<String, dynamic> _$PosicionDtoToJson(PosicionDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nombre_posicion': instance.nombrePosicion,
      'abreviatura': instance.abreviatura,
      'zona': instance.zona,
    };

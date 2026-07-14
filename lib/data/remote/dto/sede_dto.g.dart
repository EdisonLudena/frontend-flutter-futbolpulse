// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sede_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SedeDto _$SedeDtoFromJson(Map<String, dynamic> json) => SedeDto(
  id: json['id'] as String?,
  entidadId: json['entidad_id'] as String?,
  nombreSede: json['nombre_sede'] as String?,
  direccion: json['direccion'] as String?,
  latitud: parseDecimal(json['latitud']),
  longitud: parseDecimal(json['longitud']),
  capacidad: (json['capacidad'] as num?)?.toInt(),
  tipoSuperficie: json['tipo_superficie'] as String?,
  nombreEntidad: json['nombre_entidad'] as String?,
);

Map<String, dynamic> _$SedeDtoToJson(SedeDto instance) => <String, dynamic>{
  'id': instance.id,
  'entidad_id': instance.entidadId,
  'nombre_sede': instance.nombreSede,
  'direccion': instance.direccion,
  'latitud': instance.latitud,
  'longitud': instance.longitud,
  'capacidad': instance.capacidad,
  'tipo_superficie': instance.tipoSuperficie,
};

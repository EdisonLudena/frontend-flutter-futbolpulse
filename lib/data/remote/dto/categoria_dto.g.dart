// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'categoria_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoriaDto _$CategoriaDtoFromJson(Map<String, dynamic> json) => CategoriaDto(
  id: json['id'] as String?,
  entidadId: json['entidad_id'] as String?,
  nombre: json['nombre'] as String?,
  edadMinima: (json['edad_minima'] as num?)?.toInt(),
  edadMaxima: (json['edad_maxima'] as num?)?.toInt(),
  genero: json['genero'] as String?,
  activo: json['activo'] as bool?,
);

Map<String, dynamic> _$CategoriaDtoToJson(CategoriaDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'entidad_id': instance.entidadId,
      'nombre': instance.nombre,
      'edad_minima': instance.edadMinima,
      'edad_maxima': instance.edadMaxima,
      'genero': instance.genero,
      'activo': instance.activo,
    };

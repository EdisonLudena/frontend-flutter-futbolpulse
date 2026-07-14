// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jugador_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JugadorDto _$JugadorDtoFromJson(Map<String, dynamic> json) => JugadorDto(
  id: json['id'] as String?,
  entidad: json['entidad'] as String?,
  entidadId: json['entidad_id'] as String?,
  categoria: json['categoria'] as String?,
  categoriaId: json['categoria_id'] as String?,
  nombres: json['nombres'] as String?,
  apellidos: json['apellidos'] as String?,
  fechaNacimiento: json['fecha_nacimiento'] as String?,
  fotoUrl: json['foto_url'] as String?,
  numeroCamiseta: (json['numero_camiseta'] as num?)?.toInt(),
  pieDominante: json['pie_dominante'] as String?,
  nacionalidad: json['nacionalidad'] as String?,
  documentoIdentidad: json['documento_identidad'] as String?,
  estado: json['estado'] as String?,
  creadoEn: json['creado_en'] as String?,
  nombreEntidad: json['nombre_entidad'] as String?,
  nombreCategoria: json['nombre_categoria'] as String?,
);

Map<String, dynamic> _$JugadorDtoToJson(JugadorDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'entidad': instance.entidad,
      'entidad_id': instance.entidadId,
      'categoria': instance.categoria,
      'categoria_id': instance.categoriaId,
      'nombres': instance.nombres,
      'apellidos': instance.apellidos,
      'fecha_nacimiento': instance.fechaNacimiento,
      'foto_url': instance.fotoUrl,
      'numero_camiseta': instance.numeroCamiseta,
      'pie_dominante': instance.pieDominante,
      'nacionalidad': instance.nacionalidad,
      'documento_identidad': instance.documentoIdentidad,
      'estado': instance.estado,
      'creado_en': instance.creadoEn,
    };

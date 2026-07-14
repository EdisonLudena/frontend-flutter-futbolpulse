// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entidad_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EntidadDto _$EntidadDtoFromJson(Map<String, dynamic> json) => EntidadDto(
  id: json['id'] as String?,
  usuarioId: json['usuario_id'] as String?,
  nombreEntidad: json['nombre_entidad'] as String?,
  logoUrl: json['logo_url'] as String?,
  ciudad: json['ciudad'] as String?,
  pais: json['pais'] as String?,
  telefonoContacto: json['telefono_contacto'] as String?,
  estado: json['estado'] as String?,
  creadoEn: json['creado_en'] as String?,
  emailCreador: json['email_creador'] as String?,
);

Map<String, dynamic> _$EntidadDtoToJson(EntidadDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'usuario_id': instance.usuarioId,
      'nombre_entidad': instance.nombreEntidad,
      'logo_url': instance.logoUrl,
      'ciudad': instance.ciudad,
      'pais': instance.pais,
      'telefono_contacto': instance.telefonoContacto,
      'estado': instance.estado,
      'creado_en': instance.creadoEn,
    };

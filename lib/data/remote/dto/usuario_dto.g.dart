// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usuario_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UsuarioDto _$UsuarioDtoFromJson(Map<String, dynamic> json) => UsuarioDto(
  id: json['id'] as String?,
  email: json['email'] as String?,
  nombreCompleto: json['nombre_completo'] as String?,
  tipoUsuario: json['tipo_usuario'] as String?,
  estado: json['estado'] as String?,
  fechaRegistro: json['fecha_registro'] as String?,
  ultimoLogin: json['ultimo_login'] as String?,
  idioma: json['idioma'] as String?,
  unidadMedida: json['unidad_medida'] as String?,
  notificacionesActivas: json['notificaciones_activas'] as bool?,
  isStaff: json['is_staff'] as bool?,
  isActive: json['is_active'] as bool?,
);

Map<String, dynamic> _$UsuarioDtoToJson(UsuarioDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'nombre_completo': instance.nombreCompleto,
      'tipo_usuario': instance.tipoUsuario,
      'estado': instance.estado,
      'fecha_registro': instance.fechaRegistro,
      'ultimo_login': instance.ultimoLogin,
      'idioma': instance.idioma,
      'unidad_medida': instance.unidadMedida,
      'notificaciones_activas': instance.notificacionesActivas,
      'is_staff': instance.isStaff,
      'is_active': instance.isActive,
    };

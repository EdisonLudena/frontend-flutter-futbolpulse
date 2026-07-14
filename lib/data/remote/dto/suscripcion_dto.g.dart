// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'suscripcion_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SuscripcionDto _$SuscripcionDtoFromJson(Map<String, dynamic> json) =>
    SuscripcionDto(
      id: json['id'] as String?,
      usuario: json['usuario'] as String?,
      usuarioId: json['usuario_id'] as String?,
      plan: json['plan'] as String?,
      estado: json['estado'] as String?,
      fechaInicio: json['fecha_inicio'] as String?,
      fechaVencimiento: json['fecha_vencimiento'] as String?,
      metodoPago: json['metodo_pago'] as String?,
      referenciaPago: json['referencia_pago'] as String?,
      creadoEn: json['creado_en'] as String?,
    );

Map<String, dynamic> _$SuscripcionDtoToJson(SuscripcionDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'usuario': instance.usuario,
      'usuario_id': instance.usuarioId,
      'plan': instance.plan,
      'estado': instance.estado,
      'fecha_inicio': instance.fechaInicio,
      'fecha_vencimiento': instance.fechaVencimiento,
      'metodo_pago': instance.metodoPago,
      'referencia_pago': instance.referenciaPago,
      'creado_en': instance.creadoEn,
    };

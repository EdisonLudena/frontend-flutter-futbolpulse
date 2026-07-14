// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contrato_interno_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContratoInternoDto _$ContratoInternoDtoFromJson(Map<String, dynamic> json) =>
    ContratoInternoDto(
      id: json['id'] as String,
      jugadorId: json['jugador_id'] as String,
      tipoContrato: json['tipo_contrato'] as String,
      monto: parseDecimal(json['monto']),
      moneda: json['moneda'] as String,
      fechaInicio: json['fecha_inicio'] as String,
      fechaFin: json['fecha_fin'] as String?,
      descripcion: json['descripcion'] as String?,
      archivoUrl: json['archivo_url'] as String?,
      creadoEn: json['creado_en'] as String,
    );

Map<String, dynamic> _$ContratoInternoDtoToJson(ContratoInternoDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'jugador_id': instance.jugadorId,
      'tipo_contrato': instance.tipoContrato,
      'monto': instance.monto,
      'moneda': instance.moneda,
      'fecha_inicio': instance.fechaInicio,
      'fecha_fin': instance.fechaFin,
      'descripcion': instance.descripcion,
      'archivo_url': instance.archivoUrl,
      'creado_en': instance.creadoEn,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'metrica_tecnica_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MetricaTecnicaDto _$MetricaTecnicaDtoFromJson(Map<String, dynamic> json) =>
    MetricaTecnicaDto(
      id: json['id'] as String,
      reporteId: json['reporte_id'] as String,
      control: (json['control'] as num?)?.toInt(),
      paseCorto: (json['pase_corto'] as num?)?.toInt(),
      paseLargo: (json['pase_largo'] as num?)?.toInt(),
      tiro: (json['tiro'] as num?)?.toInt(),
      regate: (json['regate'] as num?)?.toInt(),
      cabeceo: (json['cabeceo'] as num?)?.toInt(),
      velocidad: (json['velocidad'] as num?)?.toInt(),
      resistencia: (json['resistencia'] as num?)?.toInt(),
      puntajeTecnico: parseDecimal(json['puntaje_tecnico']),
    );

Map<String, dynamic> _$MetricaTecnicaDtoToJson(MetricaTecnicaDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'reporte_id': instance.reporteId,
      'control': instance.control,
      'pase_corto': instance.paseCorto,
      'pase_largo': instance.paseLargo,
      'tiro': instance.tiro,
      'regate': instance.regate,
      'cabeceo': instance.cabeceo,
      'velocidad': instance.velocidad,
      'resistencia': instance.resistencia,
      'puntaje_tecnico': instance.puntajeTecnico,
    };

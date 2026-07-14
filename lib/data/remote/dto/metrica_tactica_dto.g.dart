// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'metrica_tactica_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MetricaTacticaDto _$MetricaTacticaDtoFromJson(Map<String, dynamic> json) =>
    MetricaTacticaDto(
      id: json['id'] as String,
      reporteId: json['reporte_id'] as String,
      ubicacion: (json['ubicacion'] as num?)?.toInt(),
      lecturaJuego: (json['lectura_juego'] as num?)?.toInt(),
      sacrificio: (json['sacrificio'] as num?)?.toInt(),
      liderazgo: (json['liderazgo'] as num?)?.toInt(),
      presion: (json['presion'] as num?)?.toInt(),
      trabajoEquipo: (json['trabajo_equipo'] as num?)?.toInt(),
      puntajeTactico: parseDecimal(json['puntaje_tactico']),
    );

Map<String, dynamic> _$MetricaTacticaDtoToJson(MetricaTacticaDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'reporte_id': instance.reporteId,
      'ubicacion': instance.ubicacion,
      'lectura_juego': instance.lecturaJuego,
      'sacrificio': instance.sacrificio,
      'liderazgo': instance.liderazgo,
      'presion': instance.presion,
      'trabajo_equipo': instance.trabajoEquipo,
      'puntaje_tactico': instance.puntajeTactico,
    };

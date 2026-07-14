// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_rendimiento_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TestRendimientoDto _$TestRendimientoDtoFromJson(Map<String, dynamic> json) =>
    TestRendimientoDto(
      id: json['id'] as String?,
      jugador: json['jugador'] as String?,
      velocidad30mSeg: parseDecimal(json['velocidad_30m_seg']),
      velocidad60mSeg: parseDecimal(json['velocidad_60m_seg']),
      saltoVerticalCm: (json['salto_vertical_cm'] as num?)?.toInt(),
      saltoHorizontalCm: (json['salto_horizontal_cm'] as num?)?.toInt(),
      resistenciaVo2max: parseDecimal(json['resistencia_vo2max']),
      resistenciaNivel: (json['resistencia_nivel'] as num?)?.toInt(),
      flexibilidadCm: (json['flexibilidad_cm'] as num?)?.toInt(),
      agilidadSeg: parseDecimal(json['agilidad_seg']),
      fechaTest: json['fecha_test'] as String?,
      observaciones: json['observaciones'] as String?,
    );

Map<String, dynamic> _$TestRendimientoDtoToJson(TestRendimientoDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'jugador': instance.jugador,
      'velocidad_30m_seg': instance.velocidad30mSeg,
      'velocidad_60m_seg': instance.velocidad60mSeg,
      'salto_vertical_cm': instance.saltoVerticalCm,
      'salto_horizontal_cm': instance.saltoHorizontalCm,
      'resistencia_vo2max': instance.resistenciaVo2max,
      'resistencia_nivel': instance.resistenciaNivel,
      'flexibilidad_cm': instance.flexibilidadCm,
      'agilidad_seg': instance.agilidadSeg,
      'fecha_test': instance.fechaTest,
      'observaciones': instance.observaciones,
    };

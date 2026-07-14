// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'historial_antropometrico_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HistorialAntropometricoDto _$HistorialAntropometricoDtoFromJson(
        Map<String, dynamic> json) =>
    HistorialAntropometricoDto(
      id: json['id'] as String?,
      jugador: json['jugador'] as String?,
      pesoKg: parseDecimal(json['peso_kg']),
      alturaCm: parseDecimal(json['altura_cm']),
      grasaCorporal: parseDecimal(json['grasa_corporal']),
      masaMuscular: parseDecimal(json['masa_muscular']),
      imc: parseDecimal(json['imc']),
      fechaToma: json['fecha_toma'] as String?,
      observaciones: json['observaciones'] as String?,
    );

Map<String, dynamic> _$HistorialAntropometricoDtoToJson(
        HistorialAntropometricoDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'jugador': instance.jugador,
      'peso_kg': instance.pesoKg,
      'altura_cm': instance.alturaCm,
      'grasa_corporal': instance.grasaCorporal,
      'masa_muscular': instance.masaMuscular,
      'imc': instance.imc,
      'fecha_toma': instance.fechaToma,
      'observaciones': instance.observaciones,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sesion_rehabilitacion_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SesionRehabilitacionDto _$SesionRehabilitacionDtoFromJson(
  Map<String, dynamic> json,
) => SesionRehabilitacionDto(
  id: json['id'] as String,
  lesionId: json['lesion_id'] as String,
  ejerciciosRealizados: json['ejercicios_realizados'] as String,
  duracionMinutos: (json['duracion_minutos'] as num?)?.toInt(),
  dolorNivel: (json['dolor_nivel'] as num?)?.toInt(),
  fechaSesion: json['fecha_sesion'] as String,
  fisioterapeuta: json['fisioterapeuta'] as String?,
  observaciones: json['observaciones'] as String?,
);

Map<String, dynamic> _$SesionRehabilitacionDtoToJson(
  SesionRehabilitacionDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'lesion_id': instance.lesionId,
  'ejercicios_realizados': instance.ejerciciosRealizados,
  'duracion_minutos': instance.duracionMinutos,
  'dolor_nivel': instance.dolorNivel,
  'fecha_sesion': instance.fechaSesion,
  'fisioterapeuta': instance.fisioterapeuta,
  'observaciones': instance.observaciones,
};

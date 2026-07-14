// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesion_registro_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LesionRegistroDto _$LesionRegistroDtoFromJson(Map<String, dynamic> json) =>
    LesionRegistroDto(
      id: json['id'] as String?,
      jugador: json['jugador'] as String?,
      descripcion: json['descripcion'] as String?,
      zonaCuerpo: json['zona_cuerpo'] as String?,
      tipoLesion: json['tipo_lesion'] as String?,
      gravedad: json['gravedad'] as String?,
      fechaInicio: json['fecha_inicio'] as String?,
      fechaAlta: json['fecha_alta'] as String?,
      activa: json['activa'] as bool?,
      medicoTratante: json['medico_tratante'] as String?,
      observaciones: json['observaciones'] as String?,
    );

Map<String, dynamic> _$LesionRegistroDtoToJson(LesionRegistroDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'jugador': instance.jugador,
      'descripcion': instance.descripcion,
      'zona_cuerpo': instance.zonaCuerpo,
      'tipo_lesion': instance.tipoLesion,
      'gravedad': instance.gravedad,
      'fecha_inicio': instance.fechaInicio,
      'fecha_alta': instance.fechaAlta,
      'activa': instance.activa,
      'medico_tratante': instance.medicoTratante,
      'observaciones': instance.observaciones,
    };

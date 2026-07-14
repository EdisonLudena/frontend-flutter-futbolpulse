// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'antecedentes_salud_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AntecedentesSaludDto _$AntecedentesSaludDtoFromJson(Map<String, dynamic> json) =>
    AntecedentesSaludDto(
      id: json['id'] as String?,
      jugador: json['jugador'] as String?,
      tipoSangre: json['tipo_sangre'] as String?,
      alergias: json['alergias'] as String?,
      medicamentosRegulares: json['medicamentos_regulares'] as String?,
      condicionesCronicas: json['condiciones_cronicas'] as String?,
      contactoMedicoNombre: json['contacto_medico_nombre'] as String?,
      contactoMedicoTel: json['contacto_medico_tel'] as String?,
      actualizadoEn: json['actualizado_en'] as String?,
    );

Map<String, dynamic> _$AntecedentesSaludDtoToJson(
        AntecedentesSaludDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'jugador': instance.jugador,
      'tipo_sangre': instance.tipoSangre,
      'alergias': instance.alergias,
      'medicamentos_regulares': instance.medicamentosRegulares,
      'condiciones_cronicas': instance.condicionesCronicas,
      'contacto_medico_nombre': instance.contactoMedicoNombre,
      'contacto_medico_tel': instance.contactoMedicoTel,
      'actualizado_en': instance.actualizadoEn,
    };

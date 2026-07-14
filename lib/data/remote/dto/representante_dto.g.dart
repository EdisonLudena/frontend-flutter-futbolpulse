// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'representante_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RepresentanteDto _$RepresentanteDtoFromJson(Map<String, dynamic> json) =>
    RepresentanteDto(
      id: json['id'] as String,
      jugadorId: json['jugador_id'] as String,
      nombre: json['nombre'] as String,
      telefono: json['telefono'] as String?,
      email: json['email'] as String?,
      parentesco: json['parentesco'] as String?,
      esContactoEmergencia: json['es_contacto_emergencia'] as bool,
      esAgente: json['es_agente'] as bool,
    );

Map<String, dynamic> _$RepresentanteDtoToJson(RepresentanteDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'jugador_id': instance.jugadorId,
      'nombre': instance.nombre,
      'telefono': instance.telefono,
      'email': instance.email,
      'parentesco': instance.parentesco,
      'es_contacto_emergencia': instance.esContactoEmergencia,
      'es_agente': instance.esAgente,
    };

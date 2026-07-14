// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prospecto_seguimiento_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProspectoSeguimientoDto _$ProspectoSeguimientoDtoFromJson(
  Map<String, dynamic> json,
) => ProspectoSeguimientoDto(
  id: json['id'] as String?,
  usuarioId: json['usuario_id'] as String?,
  jugadorId: json['jugador_id'] as String?,
  nombreJugador: json['nombre_jugador'] as String?,
  equipoActual: json['equipo_actual'] as String?,
  posicionId: json['posicion_id'] as String?,
  fechaNacimiento: json['fecha_nacimiento'] as String?,
  nacionalidad: json['nacionalidad'] as String?,
  estado: json['estado'] as String?,
  fechaPrimerContacto: json['fecha_primer_contacto'] as String?,
  observaciones: json['observaciones'] as String?,
  creadoEn: json['creado_en'] as String?,
);

Map<String, dynamic> _$ProspectoSeguimientoDtoToJson(
  ProspectoSeguimientoDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'usuario_id': instance.usuarioId,
  'jugador_id': instance.jugadorId,
  'nombre_jugador': instance.nombreJugador,
  'equipo_actual': instance.equipoActual,
  'posicion_id': instance.posicionId,
  'fecha_nacimiento': instance.fechaNacimiento,
  'nacionalidad': instance.nacionalidad,
  'estado': instance.estado,
  'fecha_primer_contacto': instance.fechaPrimerContacto,
  'observaciones': instance.observaciones,
  'creado_en': instance.creadoEn,
};

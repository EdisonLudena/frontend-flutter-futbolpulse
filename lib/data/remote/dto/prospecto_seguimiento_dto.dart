import 'package:json_annotation/json_annotation.dart';
import '../../../domain/model/prospecto_seguimiento.dart';

part 'prospecto_seguimiento_dto.g.dart';

@JsonSerializable()
class ProspectoSeguimientoDto {
  final String? id;
  @JsonKey(name: 'usuario_id')
  final String? usuarioId;
  @JsonKey(name: 'jugador_id')
  final String? jugadorId;
  @JsonKey(name: 'nombre_jugador')
  final String? nombreJugador;
  @JsonKey(name: 'equipo_actual')
  final String? equipoActual;
  @JsonKey(name: 'posicion_id')
  final String? posicionId;
  @JsonKey(name: 'fecha_nacimiento')
  final String? fechaNacimiento;
  final String? nacionalidad;
  final String? estado;
  @JsonKey(name: 'fecha_primer_contacto')
  final String? fechaPrimerContacto;
  final String? observaciones;
  @JsonKey(name: 'creado_en')
  final String? creadoEn;

  ProspectoSeguimientoDto({
    this.id,
    this.usuarioId,
    this.jugadorId,
    this.nombreJugador,
    this.equipoActual,
    this.posicionId,
    this.fechaNacimiento,
    this.nacionalidad,
    this.estado,
    this.fechaPrimerContacto,
    this.observaciones,
    this.creadoEn,
  });

  factory ProspectoSeguimientoDto.fromJson(Map<String, dynamic> json) =>
      _$ProspectoSeguimientoDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProspectoSeguimientoDtoToJson(this);

  ProspectoSeguimiento toDomain() => ProspectoSeguimiento(
        id: id ?? '',
        usuarioId: usuarioId ?? '',
        jugadorId: jugadorId,
        nombreJugador: nombreJugador ?? 'Prospecto sin nombre',
        equipoActual: equipoActual,
        posicionId: posicionId,
        fechaNacimiento: fechaNacimiento != null ? DateTime.parse(fechaNacimiento!) : null,
        nacionalidad: nacionalidad,
        estado: estado ?? 'Seguimiento',
        fechaPrimerContacto: fechaPrimerContacto != null ? DateTime.parse(fechaPrimerContacto!) : null,
        observaciones: observaciones,
        creadoEn: creadoEn != null ? DateTime.parse(creadoEn!) : DateTime.now(),
      );
}

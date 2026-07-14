import 'package:json_annotation/json_annotation.dart';
import '../../../domain/model/lesion_registro.dart';

part 'lesion_registro_dto.g.dart';

@JsonSerializable()
class LesionRegistroDto {
  final String? id;
  final String? jugador;
  final String? descripcion;
  @JsonKey(name: 'zona_cuerpo')
  final String? zonaCuerpo;
  @JsonKey(name: 'tipo_lesion')
  final String? tipoLesion;
  final String? gravedad;
  @JsonKey(name: 'fecha_inicio')
  final String? fechaInicio;
  @JsonKey(name: 'fecha_alta')
  final String? fechaAlta;
  final bool? activa;
  @JsonKey(name: 'medico_tratante')
  final String? medicoTratante;
  final String? observaciones;

  LesionRegistroDto({
    this.id,
    this.jugador,
    this.descripcion,
    this.zonaCuerpo,
    this.tipoLesion,
    this.gravedad,
    this.fechaInicio,
    this.fechaAlta,
    this.activa,
    this.medicoTratante,
    this.observaciones,
  });

  factory LesionRegistroDto.fromJson(Map<String, dynamic> json) =>
      _$LesionRegistroDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LesionRegistroDtoToJson(this);

  LesionRegistro toDomain() => LesionRegistro(
        id: id ?? '',
        jugadorId: jugador ?? '',
        descripcion: descripcion ?? 'Sin descripción',
        zonaCuerpo: zonaCuerpo ?? 'General',
        tipoLesion: tipoLesion,
        gravedad: gravedad,
        fechaInicio: fechaInicio != null ? DateTime.parse(fechaInicio!) : DateTime.now(),
        fechaAlta: fechaAlta != null ? DateTime.parse(fechaAlta!) : null,
        activa: activa ?? true,
        medicoTratante: medicoTratante,
        observaciones: observaciones,
      );
}

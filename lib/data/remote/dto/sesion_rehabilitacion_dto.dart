import 'package:json_annotation/json_annotation.dart';
import '../../../domain/model/sesion_rehabilitacion.dart';

part 'sesion_rehabilitacion_dto.g.dart';

@JsonSerializable()
class SesionRehabilitacionDto {
  final String id;
  @JsonKey(name: 'lesion_id')
  final String lesionId;
  @JsonKey(name: 'ejercicios_realizados')
  final String ejerciciosRealizados;
  @JsonKey(name: 'duracion_minutos')
  final int? duracionMinutos;
  @JsonKey(name: 'dolor_nivel')
  final int? dolorNivel;
  @JsonKey(name: 'fecha_sesion')
  final String fechaSesion;
  final String? fisioterapeuta;
  final String? observaciones;

  SesionRehabilitacionDto({
    required this.id,
    required this.lesionId,
    required this.ejerciciosRealizados,
    this.duracionMinutos,
    this.dolorNivel,
    required this.fechaSesion,
    this.fisioterapeuta,
    this.observaciones,
  });

  factory SesionRehabilitacionDto.fromJson(Map<String, dynamic> json) =>
      _$SesionRehabilitacionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SesionRehabilitacionDtoToJson(this);

  SesionRehabilitacion toDomain() => SesionRehabilitacion(
        id: id,
        lesionId: lesionId,
        ejerciciosRealizados: ejerciciosRealizados,
        duracionMinutos: duracionMinutos,
        dolorNivel: dolorNivel,
        fechaSesion: DateTime.parse(fechaSesion),
        fisioterapeuta: fisioterapeuta,
        observaciones: observaciones,
      );
}

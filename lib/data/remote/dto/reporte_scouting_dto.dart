import 'package:json_annotation/json_annotation.dart';
import '../../../domain/model/reporte_scouting.dart';

part 'reporte_scouting_dto.g.dart';


@JsonSerializable()
class ReporteScoutingDto {
  final String? id;
  @JsonKey(name: 'usuario_id')
  final String? usuarioId;
  @JsonKey(name: 'jugador_id')
  final String? jugadorId;
  @JsonKey(name: 'prospecto_id')
  final String? prospectoId;
  @JsonKey(name: 'valoracion_estrellas')
  final int? valoracionEstrellas;
  @JsonKey(name: 'comentario_tecnico')
  final String? comentarioTecnico;
  @JsonKey(name: 'partido_observado')
  final String? partidoObservado;
  @JsonKey(name: 'fecha_reporte')
  final String? fechaReporte;

  ReporteScoutingDto({
    this.id,
    this.usuarioId,
    this.jugadorId,
    this.prospectoId,
    this.valoracionEstrellas,
    this.comentarioTecnico,
    this.partidoObservado,
    this.fechaReporte,
  });

  factory ReporteScoutingDto.fromJson(Map<String, dynamic> json) {
    return ReporteScoutingDto(
      id: json['id']?.toString(),
      usuarioId: json['usuario']?.toString() ?? json['usuario_id']?.toString(),
      jugadorId: json['jugador']?.toString() ?? json['jugador_id']?.toString(),
      prospectoId: json['prospecto']?.toString() ?? json['prospecto_id']?.toString(),
      valoracionEstrellas: json['valoracion_estrellas'] as int?,
      comentarioTecnico: json['comentario_tecnico'] as String?,
      partidoObservado: json['partido_observado'] as String?,
      fechaReporte: json['fecha_reporte'] as String?,
    );
  }

  Map<String, dynamic> toJson() => _$ReporteScoutingDtoToJson(this);

  ReporteScouting toDomain() => ReporteScouting(
        id: id ?? '',
        usuarioId: usuarioId ?? '',
        jugadorId: jugadorId,
        prospectoId: prospectoId,
        valoracionEstrellas: valoracionEstrellas ?? 1,
        comentarioTecnico: comentarioTecnico,
        partidoObservado: partidoObservado,
        fechaReporte: fechaReporte != null ? DateTime.parse(fechaReporte!) : DateTime.now(),
      );
}

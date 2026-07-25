import 'package:json_annotation/json_annotation.dart';
import '../../../domain/model/partido.dart';

part 'partido_dto.g.dart';

@JsonSerializable()
class PartidoDto {
  final String? id;
  @JsonKey(name: 'equipo_local')
  final String? equipoLocal;
  @JsonKey(name: 'equipo_visitante')
  final String? equipoVisitante;
  final String? fecha;
  @JsonKey(name: 'tipo_partido')
  final String? tipoPartido;
  @JsonKey(name: 'goles_favor')
  final int? golesFavor;
  @JsonKey(name: 'goles_contra')
  final int? golesContra;
  @JsonKey(name: 'resultado_final')
  final String? resultadoFinal;
  @JsonKey(name: 'estado_partido')
  final String? estadoPartido;
  final String? observaciones;
  
  // Relaciones
  final String? categoria;
  final String? sede;
  final String? entidad; // Agregamos el campo entidad que viene del backend

  PartidoDto({
    this.id,
    this.equipoLocal,
    this.equipoVisitante,
    this.fecha,
    this.tipoPartido,
    this.golesFavor,
    this.golesContra,
    this.resultadoFinal,
    this.estadoPartido,
    this.observaciones,
    this.categoria,
    this.sede,
    this.entidad,
  });

  factory PartidoDto.fromJson(Map<String, dynamic> json) => _$PartidoDtoFromJson(json);

  Partido toDomain() => Partido(
        id: id ?? '',
        categoriaId: categoria ?? '',
        entidadId: entidad, // Pasamos el club al modelo de dominio
        sedeId: sede,
        equipoLocal: equipoLocal ?? 'Local',
        equipoVisitante: equipoVisitante ?? 'Visitante',
        fecha: fecha != null ? DateTime.parse(fecha!) : DateTime.now(),
        tipoPartido: tipoPartido ?? 'Liga',
        golesFavor: golesFavor ?? 0,
        golesContra: golesContra ?? 0,
        resultadoFinal: resultadoFinal,
        estadoPartido: estadoPartido ?? 'Programado',
        observaciones: observaciones,
      );
}

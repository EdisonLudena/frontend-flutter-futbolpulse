import 'package:json_annotation/json_annotation.dart';
import '../../../domain/model/metrica_tactica.dart';
import '../../../core/utils/parsers.dart';

part 'metrica_tactica_dto.g.dart';

@JsonSerializable()
class MetricaTacticaDto {
  final String id;
  @JsonKey(name: 'reporte_id')
  final String reporteId;
  final int? ubicacion;
  @JsonKey(name: 'lectura_juego')
  final int? lecturaJuego;
  final int? sacrificio;
  final int? liderazgo;
  final int? presion;
  @JsonKey(name: 'trabajo_equipo')
  final int? trabajoEquipo;
  @JsonKey(name: 'puntaje_tactico', fromJson: parseDecimal)
  final double? puntajeTactico;

  MetricaTacticaDto({
    required this.id,
    required this.reporteId,
    this.ubicacion,
    this.lecturaJuego,
    this.sacrificio,
    this.liderazgo,
    this.presion,
    this.trabajoEquipo,
    this.puntajeTactico,
  });

  factory MetricaTacticaDto.fromJson(Map<String, dynamic> json) {
    int? safeInt(dynamic val) {
      if (val == null) return null;
      if (val is int) return val;
      if (val is double) return val.toInt();
      if (val is String) return int.tryParse(val);
      return null;
    }

    return MetricaTacticaDto(
      id: json['id']?.toString() ?? '',
      reporteId: (json['reporte'] ?? json['reporte_id'])?.toString() ?? '',
      ubicacion: safeInt(json['ubicacion']),
      lecturaJuego: safeInt(json['lectura_juego']),
      sacrificio: safeInt(json['sacrificio']),
      liderazgo: safeInt(json['liderazgo']),
      presion: safeInt(json['presion']),
      trabajoEquipo: safeInt(json['trabajo_equipo']),
      puntajeTactico: parseDecimal(json['puntaje_tactico']),
    );
  }

  Map<String, dynamic> toJson() => _$MetricaTacticaDtoToJson(this);

  MetricaTactica toDomain() => MetricaTactica(
        id: id,
        reporteId: reporteId,
        ubicacion: ubicacion,
        lecturaJuego: lecturaJuego,
        sacrificio: sacrificio,
        liderazgo: liderazgo,
        presion: presion,
        trabajoEquipo: trabajoEquipo,
        puntajeTactico: puntajeTactico,
      );
}

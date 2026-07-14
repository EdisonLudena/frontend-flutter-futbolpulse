import 'package:json_annotation/json_annotation.dart';
import '../../../domain/model/metrica_tecnica.dart';
import '../../../core/utils/parsers.dart';

part 'metrica_tecnica_dto.g.dart';

@JsonSerializable()
class MetricaTecnicaDto {
  final String id;
  @JsonKey(name: 'reporte_id')
  final String reporteId;
  final int? control;
  @JsonKey(name: 'pase_corto')
  final int? paseCorto;
  @JsonKey(name: 'pase_largo')
  final int? paseLargo;
  final int? tiro;
  final int? regate;
  final int? cabeceo;
  final int? velocidad;
  final int? resistencia;
  @JsonKey(name: 'puntaje_tecnico', fromJson: parseDecimal)
  final double? puntajeTecnico;

  MetricaTecnicaDto({
    required this.id,
    required this.reporteId,
    this.control,
    this.paseCorto,
    this.paseLargo,
    this.tiro,
    this.regate,
    this.cabeceo,
    this.velocidad,
    this.resistencia,
    this.puntajeTecnico,
  });

  factory MetricaTecnicaDto.fromJson(Map<String, dynamic> json) {
    // Función auxiliar para parsear ints de forma segura
    int? safeInt(dynamic val) {
      if (val == null) return null;
      if (val is int) return val;
      if (val is double) return val.toInt();
      if (val is String) return int.tryParse(val);
      return null;
    }

    return MetricaTecnicaDto(
      id: json['id']?.toString() ?? '',
      reporteId: (json['reporte'] ?? json['reporte_id'])?.toString() ?? '',
      control: safeInt(json['control']),
      paseCorto: safeInt(json['pase_corto']),
      paseLargo: safeInt(json['pase_largo']),
      tiro: safeInt(json['tiro']),
      regate: safeInt(json['regate']),
      cabeceo: safeInt(json['cabeceo']),
      velocidad: safeInt(json['velocidad']),
      resistencia: safeInt(json['resistencia']),
      puntajeTecnico: parseDecimal(json['puntaje_tecnico']),
    );
  }

  Map<String, dynamic> toJson() => _$MetricaTecnicaDtoToJson(this);

  MetricaTecnica toDomain() => MetricaTecnica(
        id: id,
        reporteId: reporteId,
        control: control,
        paseCorto: paseCorto,
        paseLargo: paseLargo,
        tiro: tiro,
        regate: regate,
        cabeceo: cabeceo,
        velocidad: velocidad,
        resistencia: resistencia,
        puntajeTecnico: puntajeTecnico,
      );
}

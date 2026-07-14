import 'package:json_annotation/json_annotation.dart';

import '../../../domain/model/test_rendimiento.dart';
import '../../../core/utils/parsers.dart';

part 'test_rendimiento_dto.g.dart';

@JsonSerializable()
class TestRendimientoDto {
  final String? id;
  final String? jugador;
  @JsonKey(name: 'velocidad_30m_seg', fromJson: parseDecimal)
  final double? velocidad30mSeg;
  @JsonKey(name: 'velocidad_60m_seg', fromJson: parseDecimal)
  final double? velocidad60mSeg;
  @JsonKey(name: 'salto_vertical_cm')
  final int? saltoVerticalCm;
  @JsonKey(name: 'salto_horizontal_cm')
  final int? saltoHorizontalCm;
  @JsonKey(name: 'resistencia_vo2max', fromJson: parseDecimal)
  final double? resistenciaVo2max;
  @JsonKey(name: 'resistencia_nivel')
  final int? resistenciaNivel;
  @JsonKey(name: 'flexibilidad_cm')
  final int? flexibilidadCm;
  @JsonKey(name: 'agilidad_seg', fromJson: parseDecimal)
  final double? agilidadSeg;
  @JsonKey(name: 'fecha_test')
  final String? fechaTest;
  final String? observaciones;

  TestRendimientoDto({
    this.id,
    this.jugador,
    this.velocidad30mSeg,
    this.velocidad60mSeg,
    this.saltoVerticalCm,
    this.saltoHorizontalCm,
    this.resistenciaVo2max,
    this.resistenciaNivel,
    this.flexibilidadCm,
    this.agilidadSeg,
    this.fechaTest,
    this.observaciones,
  });

  factory TestRendimientoDto.fromJson(Map<String, dynamic> json) =>
      _$TestRendimientoDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TestRendimientoDtoToJson(this);

  TestRendimiento toDomain() => TestRendimiento(
        id: id ?? '',
        jugadorId: jugador ?? '',
        velocidad30mSeg: velocidad30mSeg,
        velocidad60mSeg: velocidad60mSeg,
        saltoVerticalCm: saltoVerticalCm,
        saltoHorizontalCm: saltoHorizontalCm,
        resistenciaVo2max: resistenciaVo2max,
        resistenciaNivel: resistenciaNivel,
        flexibilidadCm: flexibilidadCm,
        agilidadSeg: agilidadSeg,
        fechaTest: fechaTest != null ? DateTime.parse(fechaTest!) : DateTime.now(),
        observaciones: observaciones,
      );
}

import 'package:json_annotation/json_annotation.dart';
import '../../../domain/model/contrato_interno.dart';
import '../../../core/utils/parsers.dart';

part 'contrato_interno_dto.g.dart';

@JsonSerializable()
class ContratoInternoDto {
  final String id;
  @JsonKey(name: 'jugador_id')
  final String jugadorId;
  @JsonKey(name: 'tipo_contrato')
  final String tipoContrato;
  @JsonKey(fromJson: parseDecimal)
  final double? monto;
  final String moneda;
  @JsonKey(name: 'fecha_inicio')
  final String fechaInicio;
  @JsonKey(name: 'fecha_fin')
  final String? fechaFin;
  final String? descripcion;
  @JsonKey(name: 'archivo_url')
  final String? archivoUrl;
  @JsonKey(name: 'creado_en')
  final String creadoEn;

  ContratoInternoDto({
    required this.id,
    required this.jugadorId,
    required this.tipoContrato,
    this.monto,
    required this.moneda,
    required this.fechaInicio,
    this.fechaFin,
    this.descripcion,
    this.archivoUrl,
    required this.creadoEn,
  });

  factory ContratoInternoDto.fromJson(Map<String, dynamic> json) =>
      _$ContratoInternoDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ContratoInternoDtoToJson(this);

  ContratoInterno toDomain() => ContratoInterno(
        id: id,
        jugadorId: jugadorId,
        tipoContrato: tipoContrato,
        monto: monto,
        moneda: moneda,
        fechaInicio: DateTime.parse(fechaInicio),
        fechaFin: fechaFin != null ? DateTime.parse(fechaFin!) : null,
        descripcion: descripcion,
        archivoUrl: archivoUrl,
        creadoEn: DateTime.parse(creadoEn),
      );
}

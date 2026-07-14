import 'package:json_annotation/json_annotation.dart';
import '../../../domain/model/valoracion_economica.dart';
import '../../../core/utils/parsers.dart';

part 'valoracion_economica_dto.g.dart';

@JsonSerializable()
class ValoracionEconomicaDto {
  final String? id;
  @JsonKey(name: 'jugador_id')
  final String? jugadorId;
  final dynamic jugador;
  @JsonKey(name: 'valor_estimado', fromJson: parseDecimal)
  final double? valorEstimado;
  final String? moneda;
  @JsonKey(name: 'fecha_valoracion')
  final String? fechaValoracion;
  @JsonKey(name: 'metodo_valoracion')
  final String? metodoValoracion;
  final String? observaciones;

  ValoracionEconomicaDto({
    this.id,
    this.jugadorId,
    this.jugador,
    this.valorEstimado,
    this.moneda,
    this.fechaValoracion,
    this.metodoValoracion,
    this.observaciones,
  });

  factory ValoracionEconomicaDto.fromJson(Map<String, dynamic> json) =>
      _$ValoracionEconomicaDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ValoracionEconomicaDtoToJson(this);

  ValoracionEconomica toDomain() => ValoracionEconomica(
        id: id ?? '',
        jugadorId: jugador is String ? jugador : (jugadorId ?? ''),
        valorEstimado: valorEstimado ?? 0.0,
        moneda: moneda ?? 'USD',
        fechaValoracion: fechaValoracion != null ? DateTime.parse(fechaValoracion!) : DateTime.now(),
        metodoValoracion: metodoValoracion,
        observaciones: observaciones,
      );
}

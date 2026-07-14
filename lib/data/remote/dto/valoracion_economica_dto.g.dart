// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'valoracion_economica_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ValoracionEconomicaDto _$ValoracionEconomicaDtoFromJson(
  Map<String, dynamic> json,
) => ValoracionEconomicaDto(
  id: json['id'] as String?,
  jugadorId: json['jugador_id'] as String?,
  jugador: json['jugador'],
  valorEstimado: parseDecimal(json['valor_estimado']),
  moneda: json['moneda'] as String?,
  fechaValoracion: json['fecha_valoracion'] as String?,
  metodoValoracion: json['metodo_valoracion'] as String?,
  observaciones: json['observaciones'] as String?,
);

Map<String, dynamic> _$ValoracionEconomicaDtoToJson(
  ValoracionEconomicaDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'jugador_id': instance.jugadorId,
  'jugador': instance.jugador,
  'valor_estimado': instance.valorEstimado,
  'moneda': instance.moneda,
  'fecha_valoracion': instance.fechaValoracion,
  'metodo_valoracion': instance.metodoValoracion,
  'observaciones': instance.observaciones,
};

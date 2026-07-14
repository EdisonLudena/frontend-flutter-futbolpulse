import 'package:json_annotation/json_annotation.dart';
import '../../../domain/model/plan_alimenticio.dart';

part 'plan_alimenticio_dto.g.dart';

@JsonSerializable()
class PlanAlimenticioDto {
  final String id;
  @JsonKey(name: 'jugador_id')
  final String jugadorId;
  @JsonKey(name: 'descripcion_dieta')
  final String? descripcionDieta;
  @JsonKey(name: 'calorias_totales')
  final int? caloriasTotales;
  @JsonKey(name: 'proteina_gr')
  final int? proteinaGr;
  @JsonKey(name: 'carbohidratos_gr')
  final int? carbohidratosGr;
  @JsonKey(name: 'grasas_gr')
  final int? grasasGr;
  @JsonKey(name: 'hidratacion_ml')
  final int? hidratacionMl;
  @JsonKey(name: 'fecha_inicio')
  final String fechaInicio;
  @JsonKey(name: 'fecha_fin')
  final String? fechaFin;
  final String? nutricionista;
  final bool activo;

  PlanAlimenticioDto({
    required this.id,
    required this.jugadorId,
    this.descripcionDieta,
    this.caloriasTotales,
    this.proteinaGr,
    this.carbohidratosGr,
    this.grasasGr,
    this.hidratacionMl,
    required this.fechaInicio,
    this.fechaFin,
    this.nutricionista,
    required this.activo,
  });

  factory PlanAlimenticioDto.fromJson(Map<String, dynamic> json) =>
      _$PlanAlimenticioDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PlanAlimenticioDtoToJson(this);

  PlanAlimenticio toDomain() => PlanAlimenticio(
        id: id,
        jugadorId: jugadorId,
        descripcionDieta: descripcionDieta,
        caloriasTotales: caloriasTotales,
        proteinaGr: proteinaGr,
        carbohidratosGr: carbohidratosGr,
        grasasGr: grasasGr,
        hidratacionMl: hidratacionMl,
        fechaInicio: DateTime.parse(fechaInicio),
        fechaFin: fechaFin != null ? DateTime.parse(fechaFin!) : null,
        nutricionista: nutricionista,
        activo: activo,
      );
}
